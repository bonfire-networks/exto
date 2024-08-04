# Exto

[![hex.pm](https://img.shields.io/hexpm/v/exto)](https://hex.pm/packages/exto)
[hexdocs](https://hexdocs.pm/exto)

`Exto` provides configuration-driven Ecto schema extensibility

## Usage

### Example Schema

```elixir
defmodule My.Schema do
  use Ecto.Schema
  import Exto, only: [flex_schema: 1]

  schema "my_table" do
    field :name, :string # just normal schema things
    flex_schema(:my_app) # boom! give me the stuff
  end
end
```

### Example configuration

```elixir
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

This example won't work very well because it is redefining `foo` and `bar` 5 times, but you get the point.

Reading of configuration is done during compile time. The relations will be baked in during compilation, thus:

* Do not expect this to work in runtime config.
* You will need to rebuild all dependencies which use this macro when you change their configuration.

## Copyright and License

Copyright (c) 2020 Exto Contributors

 Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
