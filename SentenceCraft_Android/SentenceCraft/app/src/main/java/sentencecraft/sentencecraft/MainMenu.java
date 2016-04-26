package sentencecraft.sentencecraft;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MainMenu extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    /*called on button click. Will check for the button and create appropriate intent*/
    public void buttonResponse(View view){
        Intent intent;
        switch(view.getId()){
            case R.id.main_start:
                intent = new Intent(this, StartSentence.class);
                break;
            case R.id.main_continue:
                intent = new Intent(this, ContinueSentence.class);
                break;
            case R.id.main_view:
                intent = new Intent(this, ViewSentence.class);
                break;
            default:
                Log.d(getString(R.string.app_name),"button pressed did not have associated id.");
                return;
        }
        startActivity(intent);
    }
}
