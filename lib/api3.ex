defmodule Api3 do
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
        #ips = Enum.map(ifs, fn {ip, _broadaddr, _mask} -> ip end)
        #f = Enum.join(Tuple.to_list(Enum.at(ips,4)),".")
        ips = Enum.at(ifs,0)
        ip = elem(ips,0)
        f = Enum.join(Tuple.to_list(ip),".")
        node = Enum.join([n,"AB","@",f],"")
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
        ips = Enum.at(ifs,0)
        ip = elem(ips,0)
        f = Enum.join(Tuple.to_list(ip),".")
        node = Enum.join([n,"A","@",f],"")
        Node.connect String.to_atom(node)
        node2 = Enum.join([n,"B","@",f],"")
        Node.connect String.to_atom(node2)
        node3 = Enum.join([n,"AB","@",f],"")
        Node.connect String.to_atom(node3)
        init2(n+1)
    end

    def envio() do
        :timer.sleep(1000)
        cond do
            #Node.list != [] -> Enum.map(Node.list, fn (x) -> Process.send_after(x,["f1","f2"],1) end)
            Node.list != [] -> Enum.map(Node.list, fn (x) -> node_filter(x) end)
            true -> nil
        end
        init2(0)
    end
#Enum.map(Node.list, fn (x) -> Node.spawn_link(x,Api3.take([Node.self(),"f1","f2"])) end)
    def node_filter(x) do
        xs =Atom.to_string(x)
        if String.contains?(xs, "AB") do
            Node.spawn_link(x,Api3.take([Node.self(),"f1","f2","f3","f4"])) 
        end
        if String.contains?(xs, "A") do
            Node.spawn_link(x,Api3.take([Node.self(),"f1","f2"])) 
        end
        if String.contains?(xs, "B") do
            Node.spawn_link(x,Api3.take([Node.self(),"f3","f4"])) 
        end
    end
"""
def node_filter(x) do
    xs =Atom.to_string(x)
    cond do
        String.contains?(xs, "AB") -> Node.spawn_link(x,Api3.take([Node.self(),"f1","f2","f3","f4"])) 
        String.contains?(xs, "A") -> Node.spawn_link(x,Api3.take([Node.self(),"f1","f2"])) 
        String.contains?(xs, "B") -> Node.spawn_link(x,Api3.take([Node.self(),"f3","f4"])) 
        true -> nil
    end
end


    def main do
        receive do
            [h | t] -> proc_list([h | t])
        after
            100 -> init2(0)
        end
    end
"""
    def take([h | t]) do
        Node.spawn_link(h,Api3.proc_list(t))
    end

    def proc_list([h | t]) do
        apply(String.to_existing_atom("Elixir.Api3"), String.to_atom(h), [])
        proc_list(t)
    end

    def proc_list([]) do
        envio()
    end

    def f1() do
        IO.inspect "Se ejecuta f1 en api3"
    end

    def f2() do
        IO.inspect "Se ejecuta f2 en api3"
    end

    def f3() do
        IO.inspect "Se ejecuta f3 en api3"
    end

    def f4() do
        IO.inspect "Se ejecuta f4 en api3"
    end
end