import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.IntStream;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ConcurrencyTest {

   ExecutorService executor;
   private Map<String, Integer> m;

   @Before
   public void setup() {
      executor = Executors.newFixedThreadPool(20);
   }

   @Test
   public void falacy1() throws Exception {
      System.out.println("Falacy 1");
      m = new HashMap<>();
      IntStream.range(0, 500).forEach(it -> {
         executor.execute(() -> m.put("foo", 1));
         executor.execute(() -> m.put("foo", 2));
         executor.execute(() -> m.put("foo", 3));
         executor.execute(() -> System.out.println(m.get("foo")));
      });
   }

   @Test
   public void falacy2() throws Exception {
      System.out.println("Falacy 2");
      m = new Hashtable<>();
      m.put("foo", 0);
      IntStream.range(0, 500).forEach(it -> {
         executor.execute(() -> {
            int i = m.get("foo");
            m.put("foo", i+1);
            System.out.println(m.get("foo"));
         });
         executor.execute(() -> {
            int i = m.get("foo");
            m.put("foo", i-1);
            System.out.println(m.get("foo"));
         });
      });
   }
   
   @After
   public void tearDown() throws InterruptedException {
      executor.awaitTermination(2, TimeUnit.SECONDS);
      System.out.println(m);
   }

}

