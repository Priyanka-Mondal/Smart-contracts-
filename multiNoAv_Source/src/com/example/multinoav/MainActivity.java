package com.example.multinoav;
import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.Menu;
import android.view.MenuItem;
public class MainActivity extends Activity 
{
	 Queue<Integer> q = new LinkedList<Integer>();
	 Lock lock= new ReentrantLock();
	 final Handler mhand = new  Handler(Looper.getMainLooper());
	 boolean flag=true;
	 int a;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final Handler mainHandler = new  Handler(Looper.getMainLooper());
		Thread t = new Thread()
		{
			public void run()
			{
				Runnable myRunnable = new Runnable()
				{
					public void run()
					{
						lock.lock();
						try
						{
							q.clear();
							System.out.println("in C()");
						}
						finally
						{
							lock.unlock();
						}
					};
				};
				mainHandler.post(myRunnable);	
			};
		};
		t.start();
		s();
		A();
    }
    public void A()
	{
			lock.lock();
			if(!q.isEmpty())
			{
				Runnable myRunnable = new Runnable()
				{
					public void run()
					{
						q.remove();	
						System.out.println("in B()");
						lock.unlock();
					};
				};
				mhand.post(myRunnable);	
			}
			else
			{
				lock.unlock();
			}
			System.out.println("end of A()");
	}
    public void s()
	{
		q.add(55);
		q.add(88);
	}
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}

