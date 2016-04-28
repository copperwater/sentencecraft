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

        //make switch conform to settings in GlobalValues
        Switch networkSwitch = (Switch) findViewById(R.id.networkSwitch);
        Switch lexemeSwitch = (Switch) findViewById(R.id.lexemeswitch);

        //set switches
        networkSwitch.setChecked(GlobalValues.networkIsLocalhost);
        lexemeSwitch.setChecked(GlobalValues.lexemeIsWord);

        //set listener for network switch
        networkSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    GlobalValues.networkIsLocalhost = true;
                }else{
                    GlobalValues.networkIsLocalhost = false;
                }
            }
        });

        //set listener for lexemeSwitch
        lexemeSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    GlobalValues.lexemeIsWord = true;
                }else{
                    GlobalValues.lexemeIsWord= false;
                }
            }
        });
    }
}
