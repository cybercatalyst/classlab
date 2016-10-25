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

    label_opts = [class: "control-label"] ++ (opts[:label_attrs] || [])

    wrapper_html form, field, opts do
      label = label(form, field, humanize(field), label_opts)
      input = input_html(type, form, field, opts)
      error = ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  # Private methods
  defp state_class_wrapper(form, field) do
    cond do
      !form.source.action -> "" # The form was not yet submitted
      form.errors[field] -> "has-danger"
      true -> "has-success"
    end
  end

  defp state_class_input(form, field) do
    cond do
      !form.source.action -> "" # The form was not yet submitted
      form.errors[field] -> "form-control-danger"
      true -> ""
    end
  end

  defp wrapper_html(form, field, opts, do: block) do
    wrapper_opts =
      [class: "form-group #{state_class_wrapper(form, field)}"] ++ (opts[:wrapper_attrs] || [])

    content_tag :div, wrapper_opts do
      block
    end
  end

  defp input_html(:markdown_editor, form, field, opts) do
    input_opts = [class: "form-control code-mirror-markdown"] ++ clean_opts(opts)
    textarea(form, field, input_opts)
  end

  defp input_html(:select, form, field, opts) do
    input_opts = [class: "form-control"] ++ clean_opts(opts)
    Form.select(form, field, opts[:collection], input_opts)
  end

  defp input_html(type, form, field, opts) do
    input_opts =  [class: "form-control #{state_class_input(form, field)}"] ++ clean_opts(opts)
    apply(Form, type, [form, field, input_opts])
  end

  defp clean_opts(opts) do
    [:using, :collection, :wrapper_attrs, :label_attrs]
    |> List.foldr(opts, fn(value, list) -> List.keydelete(list, value, 0) end)
  end
end
