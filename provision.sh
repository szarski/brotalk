apt-get install -y git-core build-essential curl vim screen
gem install bundler

su vagrant -lc "curl -L https://get.rvm.io | bash -s stable --ruby"
su vagrant -lc "rvm install ruby 1.9.3"
# do not clone. we can use shared dir
#su vagrant -lc "[[ ! -d brotalk ]] && git clone git://github.com/szarski/brotalk.git"
su vagrant -lc "cd /vagrant && rvm 1.9.3 exec bundle install"
