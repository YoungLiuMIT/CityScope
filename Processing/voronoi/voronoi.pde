int i = 0;
int ncolors = 6;
int[] towers_x = new int[ncolors];
int[] towers_y = new int[ncolors];
color[] tower_colors = new color[ncolors];
 
int minDistance = 0;
int minIndex = 0;
 
 // this is run once.
void setup()
{
    size(350, 350);
       
    // smooth edges
    smooth();
    
    noLoop();
 
    tower_colors[0] = color(255, 0, 0); //red
    tower_colors[1] = color(0, 255, 0); //green
    tower_colors[2] = color(0, 0, 255); //blue
    tower_colors[3] = color(255, 255, 0); 
    tower_colors[4] = color(255, 0, 255);
    tower_colors[5] = color(0, 255, 255);
     
    // Set towers position, random
    for(i=0; i < ncolors; i = i+1)
    {
        towers_x[0] = int(random(width));
        towers_y[0] = int(random(height));
        towers_x[1] = int(random(width));
        towers_y[1] = int(random(height));
        towers_x[2] = int(random(width));
        towers_y[2] =int(random(height));
        towers_x[3] = int(random(width));
        towers_y[3] = int(random(height));
        towers_x[4] =  int(random(width));
        towers_y[4] = int(random(height));
        towers_x[5] =  int(random(width));
        towers_y[5] = int(random(height));
       
        
    }
    
    
    
}

void draw()

{  
  
    for(int px = 0; px < width; px++)
    {
      
         for(int py = 0; py < height; py++)
         {
           
             // Check distances to colors
             minDistance = ((px  - towers_x[0]) * (px - towers_x[0])) +  ((py  - towers_y[0]) * (py  - towers_y[0]));
             minIndex = 0;
 
             for (int nc = 1; nc < ncolors; nc++)
             {
                 int dist = ((px  - towers_x[nc]) * (px - towers_x[nc])) +  ((py  - towers_y[nc]) * (py  - towers_y[nc]));
                  
                 if (dist <= minDistance)
                 {
                     minDistance = dist;
                     minIndex = nc;
                }
            }
            stroke(tower_colors[minIndex]);
            point(px, py);
        }
        
    }
    
    
    for(int i = 0; i<200; i++){
      float x = random(width);
      float y = random(height);
      
  
      if( (((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1])) <= ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0]))) && 
      ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1])) <= ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2]))
      &&
      ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1])) <= ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3]))
      &&
      ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1])) <= ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4]))
      &&
      ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1])) <= ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])))
      {
      fill(tower_colors[1]);
      stroke(0);
      }
      
      else if( (((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2])) <= ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0]))) && 
      ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2])) <= ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1]))
      &&
      ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2])) <= ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3]))
      &&
      ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2])) <= ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4]))
      &&
      ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2])) <= ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])))
      {
      fill(tower_colors[2]);
      stroke(0);
      }
      
      else if( (((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3])) <= ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0]))) && 
      ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3])) <= ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1]))
      &&
      ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3])) <= ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2]))
      &&
      ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3])) <= ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4]))
      &&
      ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3])) <= ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])))
      {
      fill(tower_colors[3]);
      stroke(0);
      }
      
      else if( (((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])) <= ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0]))) && 
      ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])) <= ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1]))
      &&
      ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])) <= ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2]))
      &&
      ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])) <= ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3]))
      &&
      ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])) <= ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])))
      {
      fill(tower_colors[4]);
      stroke(0);
      }
      
      else if( (((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])) <= ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0]))) && 
      ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])) <= ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1]))
      &&
      ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])) <= ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2]))
      &&
      ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])) <= ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3]))
      &&
      ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5])) <= ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])))
      {
      fill(tower_colors[5]);
      stroke(0);
      }
      
      else if( (((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0])) <= ((x  - towers_x[5]) * (x - towers_x[5])) +  ((y  - towers_y[5]) * (y  - towers_y[5]))) && 
      ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0])) <= ((x  - towers_x[1]) * (x - towers_x[1])) +  ((y  - towers_y[1]) * (y  - towers_y[1]))
      &&
      ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0])) <= ((x  - towers_x[2]) * (x - towers_x[2])) +  ((y  - towers_y[2]) * (y  - towers_y[2]))
      &&
      ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0])) <= ((x  - towers_x[3]) * (x - towers_x[3])) +  ((y  - towers_y[3]) * (y  - towers_y[3]))
      &&
      ((x  - towers_x[0]) * (x - towers_x[0])) +  ((y  - towers_y[0]) * (y  - towers_y[0])) <= ((x  - towers_x[4]) * (x - towers_x[4])) +  ((y  - towers_y[4]) * (y  - towers_y[4])))
      {
      fill(tower_colors[0]);
      stroke(0);
      }
      
      
      
      ellipse(x, y, 5, 5);
    }
}

void mouseClicked(){
  clear();
  setup();
  redraw();
  
}
