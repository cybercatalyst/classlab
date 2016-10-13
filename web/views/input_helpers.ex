defmodule Classlab.InputHelpers do
  @moduledoc """
  Helpers to simplify form building.
  Example:
  <%= input f, :name %>
  """
  alias Classlab.ErrorHelpers
  alias Phoenix.HTML.Form
  use Phoenix.HTML

  def input(form, field, opts \\ []) do
    type = opts[:using] || Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      error = ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  # Private methods
  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "has-error"
      true -> "has-success"
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Form, type, [form, field, input_opts])
  end
end
