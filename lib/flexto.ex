defmodule Flexto do
  @moduledoc """
  Configuration-driven Ecto Schemata.
  """

  @doc """
  Adds additional associations dynamically from app config.

  Reads config for the given OTP application, under the name of the
  current module. Each key maps to an Ecto.Schema function:

  * `belongs_to`
  * `field`
  * `has_many`
  * `has_one`
  * `many_to_many`

  Each of these keys should map to a keyword list where the key is the
  name of the field or association and the value is one of:

  * A type
  * A tuple of type and options (keyword list)

  Example Schema:

  ```
  defmodule My.Schema do
    use Ecto.Schema
    import Flexto, only: [flex_schema: 1]

    schema "my_table" do
      field :name, :string # just normal schema things
      flex_schema(:my_app) # boom! give me the stuff
    end
  end
  ```

  Example configuration:

  ```
  config :my_app, My.Schema,
    belongs_to: [
      foo: Foo,                   # belongs_to :foo, Foo
      bar: {Bar, type: :integer}, # belongs_to :bar, Bar, type: :integer
    ],
    field: [
      foo: :string,                # field :foo, :string
      bar: {:integer, default: 4}, # field :foo, :integer, default: 4
    ],
    has_one: [
      foo: Foo,                             # has_one :foo, Foo
      bar: {Bar, foreign_key: :the_bar_id}, # has_one :bar, Bar, foreign_key: :the_bar_id
    ]
    has_many: [
      foo: Foo,                             # has_many :foo, Foo
      bar: {Bar, foreign_key: :the_bar_id}, # has_many :bar, Bar, foreign_key: :the_bar_id
    ]
    many_to_many: [
      foo: Foo,                         # many_to_many :foo, Foo
      bar: {Bar, join_through: FooBar}, # many_to_many :bar, Bar, :join_through: FooBar
    ]
  ```

  This one won't work very well because we define `foo` and `bar` 5
  times each, but I think you get the point.

  Reading of configuration is done during compile time. The relations
  will be baked in during compilation, thus:

  * Do not expect this to work in release config.
  * You will need to rebuild all dependencies which use this macro
    when you change their configuration.
  """
  defmacro flex_schema(otp_app) when is_atom(otp_app) do
    module = __CALLER__.module
    config = Application.get_env(otp_app, module, [])
    code = Enum.flat_map(config, &flex_category/1)
    quote do
      unquote_splicing(code)
    end
  end

  # flex_schema impl

  @cats [:belongs_to, :field, :has_one, :has_many, :many_to_many]

  defp flex_category({cat, items}) when cat in @cats and is_list(items),
    do: Enum.map(items, &flex_association(cat, &1))

  defp flex_category(_), do: [] # skip over anything else, they might use it!

  defp flex_association(rel, {name, type})
  when is_atom(name) and is_atom(type),
    do: flex_association(rel, name, type, [])

  defp flex_association(rel, {name, opts})
  when is_atom(name) and is_list(opts),
    do: flex_association(rel, name, opts)

  defp flex_association(rel, {name, {type, opts}})
  when is_atom(name) and is_atom(type) and is_list(opts),
    do: flex_association(rel, name, type, opts)

  defp flex_association(rel, {name, {opts}})
  when is_atom(name) and is_list(opts),
    do: flex_association(rel, name, opts)

  defp flex_association(rel, name, opts) do
    quote do
      unquote(rel)(unquote(name), unquote(opts))
    end
  end
  defp flex_association(rel, name, type, opts) do
    quote do
      unquote(rel)(unquote(name), unquote(type), unquote(opts))
    end
  end

end
