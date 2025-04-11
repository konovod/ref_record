# ref_record

Mutable structs in Crystal made easy - simple wrapper that allows to pass structs by reference without a fear that copy will be modified instead of original.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ref_record:
       github: konovod/ref_record
   ```

2. Run `shards install`

## Usage

```crystal
require "ref_record"

# use `ref_record` instead of `record` to define struct
ref_record Point, x : Int32, y : Int32

# this is just a normal struct variable
v = Point.new(123,456)

# and this is a reference to v (holds a pointer to v inside)
pt =  RefPoint.new(pointerof(v))

# pt accessors never create a copy of struct but modify it inplace:
pt.x = 1
pt.y += 1
puts pt, v
```

You can nest structures, but to make it possible you have to mark struct fields somehow, current way is prepending type name with `Struct`:
```crystal
ref_record Point, x : Int32, y : Int32
ref_record Line, start : StructPoint, finish : StructPoint, color : String

line = RefLine.new(pointerof(@some_field))
line.start.x += 1
```

## Development

There is a one big problem in my implementation. (requirement to use `StructXXX` in fields definition)

There are also lesser problems, but they are (i think) unsolvable by design:
 1. The reference use `pointer_of` that is unsafe, so `return RefPoint.new(pointerof(local_variable))` will corrupt memory in a horrible way
 2. It works only with structs defined with `ref_record`, not structs defined in stdlib or by `record` (or `struct`)

## Contributing

1. Fork it (<https://github.com/konovod/ref_record/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [konovod](https://github.com/konovod) - creator and maintainer
