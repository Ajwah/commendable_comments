# CommendableComments

  A trivial library that ensures that following module attributes do not throw a warning:

  * `@modulecomment`
  * `@comment`
  * `@typecomment`

  The value of this package is more from the semantical perspective where developers would like
  to document along their code base a variety of implementation and/or domain related matters that
  do not concern any prospective public user of the `API`.

  These could vary from documenting to what type of algorithm was leveraged to realize a particular
  implementation to highlighting the various elements of the conceptual framework that was developed
  under `Domain Driven Design`.

  `@moduledoc`, `@doc` and `@typedoc` have their usage reserved for the public `API` and thus concern
  themselves with the 'how'-usage aspect of things. The usage of the module attributes in this
  package is to anchor the 'why' aspect of things along the relevant parts of the codebase.

  For those who prefer to keep those discussions outside the codebase; inside tickets or various wikis
  they could still embed a direct URL:
  ```elixir
  defmodule A do
    use CommendableComments
    @modulecomment url: link_to_wiki/link_to_jira

    @comment url: link_to_wiki/link_to_jira
    def do_something(a, b) do
      ...
    end
  end
  ```

  In the case of diagrams that are persisted with the project locally, one could express:
  ```elixir
  @comment diagram: path_to_png
  ```
  or in case it is somewhere remote:
  ```elixir
  @comment diagram_url: link_to_online_diagram_in_google_drive
  ```

  All of these annotations are up to your personal discretion. Currently there is no real functionality
  associated with any of this.

  The ultimate ambition of this project is to enrich `ex_doc` to pick up on these attributes. Documentation can thus
  have multiple perspective views; that of a conventional user of your API as well as that of the implementor of your
  organization. Next would be to introduce the concept of `commenttest` that may be beneficial for library developers
  who would still like to document certain functionality that is not relevant for the user of such a library to know
  about.

  Whether or not this will ever come to fruitition will depend on your feedback. If you strongly oppose this concept
  altogether; then even more so I would love to learn from you.

## Installation
```elixir
def deps do
  [
    {:commendable_comments, "~> 0.1.0"}
  ]
end
```

[docs](https://hexdocs.pm/commendable_comments)

