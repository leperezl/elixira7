defmodule Api1 do
    def init() do
        init(0)
    end

    def init(n) when n<10 do
        crear(n)
    end

    def init(_n) do
        Node.set_cookie(:global)
        init2(0)
    end

    def crear(n) do
        {:ok, ifs} = :inet.getif()
        ips = Enum.map(ifs, fn {ip, _broadaddr, _mask} -> ip end)
        f = Enum.join(Tuple.to_list(Enum.at(ips,4)),".")
        node = Enum.join([n,"A","@",f],"")
        #IO.inspect node
        res = Node.ping(String.to_atom(node))
        cond do
            res == :pang -> try do
                                Node.start String.to_atom(node); IO.inspect String.to_atom(node); init(10)
                            rescue
                                _x -> init(n+1)
                            end
            true -> init(n+1)
        end
    end

    def init2(n) when n<10 do
        conectar(n)
    end

    def init2(_n) do
        envio()
    end

    def conectar(n) do
        {:ok, ifs} = :inet.getif()
        ips = Enum.map(ifs, fn {ip, _broadaddr, _mask} -> ip end)
        f = Enum.join(Tuple.to_list(Enum.at(ips,4)),".")
        node = Enum.join([n,"A","@",f],"")
        Node.connect String.to_atom(node)
        init2(n+1)
    end

    def envio() do
        :timer.sleep(1000)
        cond do
            #Node.list != [] -> Enum.map(Node.list, fn (x) -> Process.send_after(x,["f1","f2"],1) end)
            Node.list != [] -> Enum.map(Node.list, fn (x) -> Node.spawn_link(x,Api1.take([Node.self(),"f1","f2"])) end)
            true -> nil
        end
        init2(0)
    end
"""
    def main do
        receive do
            [h | t] -> proc_list([h | t])
        after
            100 -> init2(0)
        end
    end
"""
    def take([h | t]) do
        Node.spawn_link(h,Api1.proc_list(t))
    end

    def proc_list([h | t]) do
        apply(String.to_existing_atom("Elixir.Api1"), String.to_atom(h), [])
        proc_list(t)
    end

    def proc_list([]) do
        envio()
    end

    def f1() do
        IO.inspect "Se ejecuta f1"
    end

    def f2() do
        IO.inspect "Se ejecuta f2"
    end
end