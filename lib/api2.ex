defmodule Api2 do
    def main do
        for n <- 1..100, do: crear(n)
        Node.set_cookie(:global)
    end

    def con do
        receive do
            {sender, f1} -> f1()
            {sender, f2} -> f2()
        end
    end

    def f1 do
        IO.inspect "f1"
    end

    def f2 do
        IO.inspect "f2"
    end

    def crear(n) do
        node = Enum.join([n,"@Api2"],"")
        res = Node.ping(String.to_atom(node))
        cond do
            res == "pang" -> Node.start String.to_atom(node)
            true -> nil
        end
    end
    
    def descubrir do

    end
end