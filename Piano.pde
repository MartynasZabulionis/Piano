import java.util.*; //<>//
import java.util.HashMap;
import processing.sound.*;

//Basado en el ejemplo de Minim CreateAnInstrument
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

int Y_AXIS = 1;
int X_AXIS = 2;

Boolean[] pressedBlack = new Boolean[]{false, false, false, false, false, false, false};
Boolean[] pressedWhite = new Boolean[]{false, false, false, false, false, false, false, false};
HashMap<Character, Integer> keysBlack, keysWhite;

String [] whiteNotes = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};

String [] blackNotes = {"C5", "D5", "E5", "F5", "G5", "A6", "B6"};

class SineInstrument implements Instrument
{
        Oscil wave;
        Line ampEnv;

        SineInstrument(float frequency)
        {
                // Oscilador sinusoidal con envolvente
                wave   = new Oscil(frequency, 0, Waves.SINE);
                ampEnv = new Line();
                ampEnv.patch(wave.amplitude);
        }

        // Secuenciador de notas
        void noteOn(float duration)
        {
                // Amplitud de la envolvente
                ampEnv.activate(duration, 0.05f, 0);
                // asocia el oscilador a la salida
                wave.patch(out);
        }

        // Final de la nota
        void noteOff()
        {
                wave.unpatch(out);
        }
}



void setup()
{
    minim = new Minim(this);
    out = minim.getLineOut();
       
    keysBlack = new HashMap<Character, Integer>();
    keysBlack.put('s', 0);
    keysBlack.put('d', 1);
    keysBlack.put('f', 2);
    keysBlack.put('g', 3);
    keysBlack.put('h', 4);
    keysBlack.put('j', 5);
    keysBlack.put('k', 6);
    
    keysWhite = new HashMap<Character, Integer>();
    keysWhite.put('z', 0);
    keysWhite.put('x', 1);
    keysWhite.put('c', 2);
    keysWhite.put('v', 3);
    keysWhite.put('b', 4);
    keysWhite.put('n', 5);
    keysWhite.put('m', 6);
    keysWhite.put(',', 7);
    
    size (1000, 300);
    
    setGradient(0, 0, width, height, color(255), color(150), Y_AXIS);
    
    stroke(0);
    strokeWeight(3);
    fill(0);
    for (int i = 1; i < 8; ++i)
    {
            line(width / 8 * i, 0, width / 8 * i, height);
            setGradient(width / 8 * i - width / 32, 0, width / 16, height / 2, color(50), color(0), Y_AXIS);
    }
    //noLoop();
}
void draw()
{

}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
void keyPressed()
{
        Integer k = keysBlack.get(key);
        if (k != null)
        {
                if (pressedBlack[k])
                        return;
                        
                out.playNote(0.0, 1.3, new SineInstrument(Frequency.ofPitch(blackNotes[k]).asHz()));  
                setGradient(width / 8 * (k + 1) - width / 32, 0, width / 16, height / 2, color(0), color(50), Y_AXIS);
                pressedBlack[k] = true;
        }
        else
        {
                k = keysWhite.get(key);
                
                if (k == null || pressedWhite[k])
                        return;
                        
                pressedWhite[k] = true;
                out.playNote(0.0, 1.3, new SineInstrument(Frequency.ofPitch(whiteNotes[k]).asHz()));  
                setGradient(width / 8 * k, 0, width / 8, height, color(150), color(255), Y_AXIS);
                
                stroke(0);
                for (int i = 1; i < 8; ++i)
                {
                        line(width / 8 * i, 0, width / 8 * i, height);
                        if (pressedBlack[i - 1])
                                setGradient(width / 8 * i - width / 32, 0, width / 16, height / 2, color(0), color(50), Y_AXIS);
                        else
                                setGradient(width / 8 * i - width / 32, 0, width / 16, height / 2, color(50), color(0), Y_AXIS);
                }
        }
}
void keyReleased()
{
        Integer k = keysBlack.get(key);
        if (k != null)
        {
                setGradient(width / 8 * (k + 1) - width / 32, 0, width / 16, height / 2, color(50), color(0), Y_AXIS);
                pressedBlack[k] = false;
        }
        else
        {
                k = keysWhite.get(key);
                
                if (k == null)
                        return; 
                        
                pressedWhite[k] = false;
                setGradient(width / 8 * k, 0, width / 8, height, color(255), color(150), Y_AXIS);
                
                stroke(0);
                for (int i = 1; i < 8; ++i)
                {
                        line(width / 8 * i, 0, width / 8 * i, height);
                        if (pressedBlack[i - 1])
                                setGradient(width / 8 * i - width / 32, 0, width / 16, height / 2, color(0), color(50), Y_AXIS);
                        else
                                setGradient(width / 8 * i - width / 32, 0, width / 16, height / 2, color(50), color(0), Y_AXIS);
                }
        }
}
