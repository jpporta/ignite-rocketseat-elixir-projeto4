# ReportsGenerator

# 💻 Sobre o desafio

Nesse desafio, você deverá gerar o mesmo relatório com os mesmos dados do desafio anterior mas dessa vez os dados estão fracionados em três arquivos com 10 mil linhas cada e o relatório deve ser gerado usando esses três arquivos em paralelo.

Observe que o resultado final do cálculo de horas de cada pessoa para ano, mês e total de horas deve ser o mesmo do desafio anterior, já que os dados continuam iguais.

O relatório gerado a partir dos arquivos (que estão disponíveis para download logo abaixo) deve estar no seguinte formato:

```elixir
%{
  all_hours: %{
        danilo: 500,
        rafael: 854,
        ...
    },
  hours_per_month: %{
        danilo: %{
            janeiro: 40,
            fevereiro: 64,
            ...
        },
        rafael: %{
            janeiro: 52,
            fevereiro: 37,
            ...
        }
    },
  hours_per_year: %{
        danilo: %{
            2016: 276,
            2017: 412,
            ...
        },
        rafael: %{
            2016: 376,
            2017: 348,
            ...
        }
    }
}
```

Os caracteres `...` é o espaço onde ficaria o resto dos dados. Esse é apenas um exemplo visual do que o retorno da função deve possuir, beleza?

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `reports_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reports_generator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/reports_generator](https://hexdocs.pm/reports_generator).

