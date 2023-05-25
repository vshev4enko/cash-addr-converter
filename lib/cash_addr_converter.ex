defmodule CashAddrConverter do
  @moduledoc """
  Documentation for `CashAddrConverter`.
  """

  @doc """
  Takes a address string in Legacy or CashAddress format and returns all formats.

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
  @spec convert(String.t()) :: {:ok, map()} | {:error, %ErlangError{} | {pos_integer(), term()}}
  def convert(address) do
    executable = Application.app_dir(:cash_addr_converter, executable())

    case System.cmd(executable, [address]) do
      {data, 0} -> Jason.decode(data)
      {data, code} -> {:error, {code, data}}
    end
  rescue
    error -> {:error, error}
  end

  defp executable do
    case :os.type() do
      {:unix, :darwin} -> "priv/darwin/addrconv"
      {:unix, :linux} -> "priv/linux/addrconv"
    end
  end
end
