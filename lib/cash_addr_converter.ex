defmodule CashAddrConverter do
  @moduledoc """
  Documentation for `CashAddrConverter`.
  """

  @port_timeout :timer.seconds(5)

  @doc """
  Convert the address to all possible forms.

  ## Examples

      iex> CashAddrConverter.convert("qr2z7dusk64qn960h9vspf2ezewl0pla9gcpnk35f0")
      {:ok,
      %{
        "qr2z7dusk64qn960h9vspf2ezewl0pla9gcpnk35f0" => %{
          "cashaddr" => "bitcoincash:qr2z7dusk64qn960h9vspf2ezewl0pla9gcpnk35f0",
          "copay" => "CbopPQbQCharXXVr9GMyUqJP3y9RfcbHaf",
          "hash" => "0xD42F3790B6AA09974FB95900A559165DF787FD2A",
          "legacy" => "1LLvpNFLKecKdPbRTX33uKgMRqw1qaVUFu"
        }
      }}

  """
  def convert(address) do
    path = Application.app_dir(:cash_addr_converter, executable())
    port = Port.open({:spawn_executable, path}, [:binary, args: [address]])

    receive do
      {^port, {:data, data}} ->
        Port.close(port)
        Jason.decode(data)
    after
      @port_timeout ->
        Port.close(port)
        {:error, :port_timeout}
    end
  end

  defp executable do
    case :os.type() do
      {:unix, :darwin} -> "priv/darwin/addrconv"
      {:unix, :linux} -> "priv/linux/addrconv"
    end
  end
end
