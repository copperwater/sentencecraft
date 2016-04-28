package sentencecraft.sentencecraft;

import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.widget.CompoundButton;
import android.widget.Switch;

public class Settings extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        //make switch conform to settings in GlobalMethods
        Switch networkSwitch = (Switch) findViewById(R.id.networkSwitch);
        Switch lexemeSwitch = (Switch) findViewById(R.id.lexemeswitch);

        //set switches
        networkSwitch.setChecked(GlobalMethods.networkIsLocalhost);
        lexemeSwitch.setChecked(GlobalMethods.lexemeIsWord);

        //set listener for network switch
        networkSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    GlobalMethods.networkIsLocalhost = true;
                }else{
                    GlobalMethods.networkIsLocalhost = false;
                }
            }
        });

        //set listener for lexemeSwitch
        lexemeSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    GlobalMethods.lexemeIsWord = true;
                }else{
                    GlobalMethods.lexemeIsWord= false;
                }
            }
        });
    }
}
