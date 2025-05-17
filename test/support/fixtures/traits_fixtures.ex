defmodule Spectrumed.TraitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spectrumed.Traits` context.
  """

  @doc """
  Generate a trait.
  """
  def trait_fixture(attrs \\ %{}) do
    {:ok, trait} =
      attrs
      |> Enum.into(%{
        bullets: ["option1", "option2"],
        description: "some description"
      })
      |> Spectrumed.Traits.create_trait()

    trait
  end
end
