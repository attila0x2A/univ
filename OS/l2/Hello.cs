using System;
using System.Threading;
using System.Threading.Tasks;

public class Hello
{
    public static double f(double x)
    {
        Console.WriteLine("F");
        return 1;
    }

    public static double g(double x)
    {
        Console.WriteLine("G");
        Thread.Sleep(20000);
        return 2;
    }

    private static volatile bool has_finished = false;

    public async static void DoStuff()
    {
        Console.WriteLine("Hello World!");
        var cancellationToken = new CancellationToken();
        double? fres = null, gres = null;
        int timeout = 2000;
        bool ask = true;

        var fr = Task.Run(() => f(10));
        var gr = Task.Run(() => g(10));
        while (true)
        {
            if (fres == null && await Task.WhenAny(fr, Task.Delay(timeout, cancellationToken)) == fr)
            {
                fres = await fr;
                timeout *= 2;
            }
            if (fres == 0 || fres != null && gres != null) break;
            if (gres == null && await Task.WhenAny(gr, Task.Delay(timeout, cancellationToken)) == gr)
            {
                gres = await gr;
                timeout *= 2;
            }
            if (gres == 0 || fres != null && gres != null) break;

            bool ask_again = ask;
            while(ask_again)
            {
                int choose;
                Console.WriteLine("What do you want to do?");
                Console.WriteLine("1. Continue");
                Console.WriteLine("2. Continue and stop asking");
                Console.WriteLine("3. Stop execution");
                bool result = Int32.TryParse(Console.ReadLine(), out choose);
                if (result)
                {
                    ask_again = false;
                    if (choose == 2) // Continue and don't ask
                    {
                        ask = false;
                    }
                    else if (choose == 3) // Stop
                    {
                        Hello.has_finished = true;
                    }
                    else if (choose != 1)
                    {
                        ask_again = true;
                    }
                }
            }
        }
        if (fres == 0 || gres == 0)
        {
            Console.WriteLine("Result " + 0);
        }
        else
        {
            Console.WriteLine("Result " + fres * gres);
        }
        Hello.has_finished = true;
    }

    public static void Main()
    {
        DoStuff();
        while(!Hello.has_finished);
    }
}
