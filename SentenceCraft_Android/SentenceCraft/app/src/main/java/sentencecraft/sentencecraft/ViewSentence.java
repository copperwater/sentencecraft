package sentencecraft.sentencecraft;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;

import java.util.Random;

public class ViewSentence extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_sentence);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }

    public void changetext(View view){
        String me = "";
        Random myrand = new Random();
        for(int i = 0; i < 20; ++i){
            me += myrand.nextInt(10);
        }
        Button but = (Button) findViewById(R.id.test);
        but.setText(me);
    }

}
