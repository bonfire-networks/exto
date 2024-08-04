defmodule Exto do
  @moduledoc "./README.md" |> File.stream!() |> Enum.drop(1) |> Enum.join()

  @doc """
  Adds additional associations dynamically based on the config found under the name of the current module for the given OTP application. 
  
  Each key maps to an Ecto.Schema function:

  * `belongs_to`
  * `field`
  * `has_many`
  * `has_one`
  * `many_to_many`

  Each of these keys should map to a keyword list where the key is the name of the field or association and the value is one of:

  * A type
  * A tuple of type and options (keyword list)

  """
  defmacro flex_schema(otp_app) when is_atom(otp_app) do
    module = __CALLER__.module
    config = Application.get_env(otp_app, module, [])
    code = Enum.flat_map(config, &flex_category/1)

    quote do
      (unquote_splicing(code))
    end
  end

  # flex_schema impl

  @cats [:belongs_to, :field, :has_one, :has_many, :many_to_many]

  defp flex_category({:code, code}), do: [code]

  defp flex_category({cat, items}) when cat in @cats and is_list(items),
    do: Enum.map(items, &flex_association(cat, &1))

  # skip over anything else, they might use it!
  defp flex_category(_), do: []

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
