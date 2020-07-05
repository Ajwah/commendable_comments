defmodule CommendableComments.MixProject do
  use Mix.Project
  @vsn "0.1.0"
  @github "https://github.com/Ajwah/commendable_comments"
  @module_name "CommendableComments"
  
  def project do
    [
      app: :commendable_comments,
      version: @vsn,
      description: "Document the why of your Elixir code-base.",
      package: %{
        licenses: ["Apache-2.0"],
        source_url: @github,
        links: %{"GitHub" => @github}
      },
      docs: [
        main: @module_name,
        extras: ["README.md"]
      ],
      aliases: [docs: &build_docs/1],
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.path_for(:escripts), "ex_doc")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed"
    end

    args = [@module_name, @vsn, Mix.Project.compile_path()]
    opts = ~w[--main #{@module_name} --source-ref v#{@vsn} --source-url #{@github}]
    System.cmd(ex_doc, args ++ opts)
    Mix.shell().info("Docs built successfully")
  end
end
