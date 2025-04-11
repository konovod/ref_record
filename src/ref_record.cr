abstract struct RefStruct(T)
  def self.malloc
    self.new(Pointer(T).malloc(1))
  end

  def value
    @raw.value
  end

  def value=(v : T)
    @raw.value = v
  end

  def self.unsafe_from(ptr)
    self.new(ptr.as(Pointer(T)))
  end

  def self.from(bytes : Bytes)
    raise "size too small" if bytes.size < sizeof(T)
    self.new(bytes.to_unsafe.as(Pointer(T)))
  end
end

macro ref_record(name, *properties)
  {% for prop in properties %}
    {% if !prop.is_a?(TypeDeclaration) %}
      {% raise "Type must be explicit in ref_record: #{prop}" %}
    {% end %}
  {% end %}

  record({{name}}, {{properties.splat}}) do
    {% for prop in properties %}
      setter {{prop.var}}
    {% end %}
  end

  alias Struct{{name}} = {{name}}

  struct Ref{{name.id}} < RefStruct({{name.id}})
    @raw : Pointer({{name.id}})

    def initialize(@raw)
    end

    {% for prop in properties %}
      {% typ = prop.type.id %}
      {% is_struct = false %}
      {% if prop.type.id.starts_with?("Struct") %}
        {% typ = typ[6..] %}      
        {% is_struct = true %}
      {% end %}
      def {{prop.var.id}}=(value : {{typ}})
        @raw.value.{{prop.var.id}} = value
      end
      {% if is_struct %}
        def {{prop.var.id}} :  Ref{{typ}}
          base = @raw.as(UInt8*)
          v = base + offsetof({{name.id}}, @{{prop.var.id}})
          Ref{{typ}}.new(v.as(Pointer({{typ}})))
        end
      {% else %}      
        def {{prop.var.id}} : {{typ}}
          @raw.value.{{prop.var.id}}
        end
        {% typ = typ.stringify.gsub(/StaticArray\((.*), (.*)\)/, "\\1").id %}
        def ptr_{{prop.var.id}} : Pointer({{typ}})
          base = @raw.as(UInt8*)
          v = base + offsetof({{name.id}}, @{{prop.var.id}})
          v.as(Pointer({{typ}}))
        end
      {% end %}      
    {% end %}

  end

end
