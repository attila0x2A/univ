import java.util.Random;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;


class Customer {
    public int id;
    public Customer(int id) {
        this.id = id;
    }
}

class Barber implements Runnable {
    private ArrayBlockingQueue<Customer> hollQ;

    public Barber(ArrayBlockingQueue<Customer> hollQ) {
        this.hollQ = hollQ;
    }

    @Override
    public void run() {
        System.out.println("asdasda");
        while (true) {
            System.out.println("Waiting customer!");
            Customer cus;
            try {
                cus = this.hollQ.take();
            } catch (InterruptedException e) {
                e.printStackTrace();
                return;
            }
            System.out.println("Cutting customer " + cus.id + "!");
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("Cut customer " + cus.id + "!");
        }
    }
}

class CustomerManager implements Runnable {
    private LinkedBlockingQueue<Customer> outside;
    private ArrayBlockingQueue<Customer> hollQ;

    public CustomerManager(LinkedBlockingQueue<Customer> outside, ArrayBlockingQueue<Customer> hollQ) {
        this.outside = outside;
        this.hollQ = hollQ;
    }

    public void addCustomer(Customer cus) {
        if (outside.size() > 0 || hollQ.remainingCapacity() == 0) {
            System.out.println("Customer " + cus.id + " waiting outside");
            try {
                outside.put(cus);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Customer " + cus.id + " waiting in the holl");
            try {
                hollQ.put(cus);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void run() {
        while (true) {
            try {
                Customer cus = outside.take();
                hollQ.put(cus);
                System.out.println("Customer " + cus.id + " moved from outside into the holl");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class Hello {

    private static void addCustomer(Customer cus, ArrayBlockingQueue<Customer> out, ArrayBlockingQueue<Customer> holl) {
    }

    public static void main(String[] args) {
        System.out.println("Starting programm.");

        Random random = new Random();
        int hollCapacity = 3;
        ArrayBlockingQueue<Customer> hollQ = new ArrayBlockingQueue<Customer>(hollCapacity);
        LinkedBlockingQueue<Customer> outside = new LinkedBlockingQueue<Customer>();
        CustomerManager cman = new CustomerManager(outside, hollQ);

        new Thread(null, cman, "CustomerManager").start();
        new Thread(null, new Barber(hollQ), "Barber").start();

        int id = 1;
        while (true) {
            try {
                Thread.sleep(random.nextInt(8000));
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            cman.addCustomer(new Customer(id++));
        }
    }
}
