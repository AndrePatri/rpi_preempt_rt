
Simple utilities for crosscompiling the Linux kernel for a RPI host and setting it up.
Used to automate the software setup of [git@github.com:AndPatr/wheebbot_packages.git](git@github.com:AndPatr/wheebbot_packages.git)

On the host pc (crosscompiling kernel):

- Go to [https://wiki.linuxfoundation.org/realtime/start](https://wiki.linuxfoundation.org/realtime/start), click on "Latest Stable Version" and look for the name of the most recent stable kernel

- Run `git clone git@github.com:AndPatr/rpi_preempt_rt.git` 

- Edit `setup_rpi.bash` with the name of the kernel you want to crosscompile 

- Run `./crosscompile.bash`

- Push the newly compiled .deb packages to github 

On the PI:

- Generate an ssh key for the Pi with `ssh-keygen -t ed25519 -C "your_email@example.com"` and add it to your Github account

- Run `git clone git@github.com:AndPatr/rpi_preempt_rt.git` 
								
- Go inside rpi_preempt_rt and run `./setup_rpi.bash` &rarr; the RPI will reboot to load the new rt kernel