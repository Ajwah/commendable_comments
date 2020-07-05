defmodule CommendableCommentsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @baseline %{
    unused_module_attrs: """
    defmodule A do
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
    end
    """,
    used_module_attrs: """
    defmodule B do
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "

      def modulecomment, do: @modulecomment
    end
    """,
    unused_module_attrs_but_accumulate_true: """
    defmodule C do
      Module.register_attribute(__MODULE__, :modulecomment, accumulate: true)

      @modulecomment "This is being set but not used"
    end
    """
  }
  @commendable_comments_scenarios %{
    zero_attributes: """
    defmodule $$ do
      use CommendableComments
    end
    """,
    one_attribute: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
    end
    """,
    two_attributes: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
      @comment "The purpose of this section is to provide documentation geared towards maintainers of this definition. "
    end
    """,
    all_attributes: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
      @comment "The purpose of this section is to provide documentation geared towards maintainers of this definition. "
      @typecomment "The purpose of this section is to provide documentation geared towards maintainers of this type. "
    end
    """,
    all_attributes_with_usage: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
      @comment "The purpose of this section is to provide documentation geared towards maintainers of this definition. "
      @typecomment "The purpose of this section is to provide documentation geared towards maintainers of this type. "
      def comments, do: {@modulecomment, @comment, @typecomment}
    end
    """,
    all_attributes_and_non_supported_attribute_without_usage: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "The purpose of this section is to provide documentation geared towards maintainers of this module. "
      @comment "The purpose of this section is to provide documentation geared towards maintainers of this definition. "
      @typecomment "The purpose of this section is to provide documentation geared towards maintainers of this type. "

      @non_supported_attribute "This should raise a warning"
    end
    """,
    attributes_multiple_times: """
    defmodule $$ do
      use CommendableComments
      @modulecomment "first time"
      @comment "first time"
      @typecomment "first time"

      @modulecomment "second time"
      @comment "second time"
      @typecomment "second time"

      @modulecomment "third time"
      @comment "third time"
      @typecomment "third time"

      @modulecomment "fourth time"
      @comment "fourth time"
      @typecomment "fourth time"
    end
    """
  }

  describe "Baseline" do
    @tag module_to_compile: @baseline.unused_module_attrs,
         warning:
           "warning: module attribute @modulecomment was set but never used\n  nofile:2\n\n"
    test "Unused module attributes raise a warning", ctx do
      ctx.warning
      |> assert_capture_io(fn -> Code.compile_string(ctx.module_to_compile) end)
    end

    @tag module_to_compile: @baseline.used_module_attrs, warning: ""
    test "Used module attributes do not raise a warning", ctx do
      ctx.warning
      |> assert_capture_io(fn -> Code.compile_string(ctx.module_to_compile) end)
    end

    @tag module_to_compile: @baseline.unused_module_attrs_but_accumulate_true, warning: ""
    test "Unused module attributes but registered with `accumulate: true` do not raise a warning",
         ctx do
      ctx.warning
      |> assert_capture_io(fn -> Code.compile_string(ctx.module_to_compile) end)
    end
  end

  describe "CommendableComments" do
    test "All Scenarios" do
      @commendable_comments_scenarios
      |> Enum.each(fn {scenario, template} ->
        module_to_compile = String.replace(template, "$", Macro.camelize(scenario |> to_string))

        warning =
          if scenario == :all_attributes_and_non_supported_attribute_without_usage do
            "warning: module attribute @non_supported_attribute was set but never used\n  nofile:7\n\n"
          else
            ""
          end

        warning
        |> assert_capture_io(fn -> Code.compile_string(module_to_compile) end)
      end)
    end
  end

  def assert_capture_io(expected, device \\ :stderr, fun) when is_function(fun) do
    actual =
      device
      |> capture_io(fun)
      |> strip_ansi_escape_codes

    assert expected == actual
  end

  def strip_ansi_escape_codes(str) do
    str
    |> String.replace(~r/\e\[\d*m/, "")
  end
end
