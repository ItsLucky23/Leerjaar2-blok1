// klein programatje voor de git opdracht van blok 1

using System;

Console.Write("typ een nummer: ");
string? invoer = Console.ReadLine();

if (invoer is null)
{
    Console.WriteLine("geen invoer");
}
else if (!int.TryParse(invoer, out int nummer))
{
    Console.WriteLine("dat is geen nummer");
}
else if (nummer == 1)
{
    Console.WriteLine("BOEM!!");
}
else
{
    Console.WriteLine("dat was geen 1");
}
