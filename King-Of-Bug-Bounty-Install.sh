#!/bin/bash

###############################################################################
# arch-based system's KingOfBugBountyTips script to download all tools needed #
###############################################################################

if [ ! $(head -1 /etc/shadow 2>&-) ];then
	printf "\nERROR: Run as Privileged User or Root!\n\n"
	exit 1
fi

check()
{
	if [ "$(which $1 2>/dev/null)" = "" ];then
		printf "\n\e[1;31mERROR:\e[1;37m $1 command \e[0mnot found in\e[1;37m $PATH \e[0m\n\n"
		exit 1
	fi
}


export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/home/$USER/go/bin:$PWD:$PATH"

# verifies that the necessary binaries for the execution of the script are installed correctly

check go      # pacman -S go
check curl    # pacman -S curl
check git     # pacman -S git
check wget    # pacman -S wget
check python3 # pacman -S python
check pip3    # pacman -S python-pip
check unzip   # pacman -S unzip

# case all dependencies (one-liner): pacman -S go curl git wget python python-pip unzip --noconfirm --overwrite '*'

# directory where the tools will be installed
_dir="/opt"

# alias directory where the tools will be recognized by the system
_path="/usr/local/bin/"

# home user
_user="user"

# checks if "go/bin" is in the system path
[ ! "$(grep 'go/bin' /home/$_user/.zshrc)" ] && printf "export PATH=$PATH:/home/$_user/go/bin" >> /home/$_user/.zshrc
[ ! "$(grep 'go/bin' /root/.zshrc)" ] && printf "export PATH=$PATH:/home/$_user/go/bin" >> /root/.zshrc

# % API Secret-Keys and Tokens (replace with your API key's) % #
GITHUB_API_TOKEN=""
VIRUSTOTAL_API_KEY=""
CHAOS_API_KEY=""
FACEBOOK_API_TOKEN=""
SPYSE_API_KEY=""
SECURITYTRAILS_API_KEY=""
SHODAN_API_KEY=""

######################################################################

printf "\n# API TOKENS #\n
export VT_API_KEY=$VIRUSTOTAL_API_KEY
export findomain_virustotal_token=$VIRUSTOTAL_API_KEY
export findomain_fb_token=$FACEBOOK_API_TOKEN
export findomain_spyse_token=$SPYSE_API_KEY
export findomain_securitytrails_token=$SECURITYTRAILS_API_KEY
export CHAOS_API_KEY=$CHAOS_API_KEY

" >> /home/$_user/.zshrc

######################################################################

printf "\n# API TOKENS #\n
export VT_API_KEY=$VIRUSTOTAL_API_KEY
export findomain_virustotal_token=$VIRUSTOTAL_API_KEY
export findomain_fb_token=$FACEBOOK_API_TOKEN
export findomain_spyse_token=$SPYSE_API_KEY
export findomain_securitytrails_token=$SECURITYTRAILS_API_KEY
export CHAOS_API_KEY=$CHAOS_API_KEY

" >> /root/.zshrc

######################################################################

# @ Subfinder API Keys (replace with your API key's) @ #

_setAPIs()
{
printf "
bevigil: []
binaryedge: []
bufferover: []
c99: []
censys: []
certspotter: []
chaos: []
chinaz: []
dnsdb: []
dnsrepo: []
fofa: []
fullhunt: []
github: []
hunter: []
intelx: []
passivetotal: []
quake: []
robtex: []
securitytrails: []
shodan: []
threatbook: []
virustotal: []
whoisxmlapi: []
zoomeye: []
zoomeyeapi: []
"
}


# update/refresh pacman packages database
pacman -Syy

chrome_install()
{
	if [ "$(which yay 2>/dev/null)" = "" ];then
		cd /$_dir
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -sif
		rm -rf /$_dir/yay
	fi

	su $_user -c 'yay -S google-chrome --noconfirm'
	mv $(which google-chrome-stable) /usr/bin/google-chrome
}

_init=`date +%s`

# downloading Amass
cd /$_dir
git clone https://github.com/OWASP/Amass
cd Amass/cmd/amass
go get
go build
ln -sf $PWD/amass $_path/amass

# downloading Anew
cd /$_dir
git clone https://github.com/tomnomnom/anew
cd anew
go get
go build
ln -sf $PWD/anew $_path/anew

# downloading Anti-burl
cd /$_dir
mkdir anti-burl
cd anti-burl
curl -OskL https://raw.githubusercontent.com/tomnomnom/hacks/master/anti-burl/main.go
go build -o anti-burl main.go
ln -sf $PWD/anti-burl $_path/anti-burl

# downloading assetfinder
cd /$_dir
su $_user -c 'go install github.com/tomnomnom/assetfinder@latest'

# downloading airixss
cd /$_dir
git clone https://github.com/ferreiraklet/airixss
cd airixss
go build airixss.go
ln -sf $PWD/airixss $_path/airixss

# downloading bhedak
cd /$_dir
wget -O bhedak https://raw.githubusercontent.com/R0X4R/bhedak/main/bhedak.py -q
chmod +x bhedak
mv bhedak $_path/bhedak

# downloading cf-check
cd /$_dir
git clone https://github.com/dwisiswant0/cf-check
cd cf-check
go get
go build
ln -sf $PWD/cf-check $_path/cf-check

# downloading Chaos
cd /$_dir
git clone https://github.com/projectdiscovery/chaos-client
cd chaos-client/cmd/chaos
go get
go build
ln -sf $PWD/chaos $_path/chaos

# downloading cariddi
cd /$_dir
git clone https://github.com/edoardottt/cariddi
cd cariddi/cmd/cariddi
go get
go build
ln -sf $PWD/cariddi $_path/cariddi

# downloading dalfox
cd /$_dir
git clone https://github.com/hahwul/dalfox
cd dalfox
go get
go build
ln -sf $PWD/dalfox $_path/dalfox

# downloading dnsgen
cd /$_dir
git clone https://github.com/ProjectAnte/dnsgen
cd dnsgen
pip3 install -r requirements.txt
python3 setup.py install

# downloading filter-resolved
cd /$_dir
mkdir filter-resolved
cd filter-resolved
curl -OskL https://raw.githubusercontent.com/tomnomnom/hacks/master/filter-resolved/main.go
go build -o filter-resolved main.go
ln -sf $PWD/filter-resolved $_path/filter-resolved

# downloading findomain
cd /$_dir
curl -LskO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
unzip findomain-linux-i386.zip
chmod +x findomain
mv findomain /usr/local/bin/findomain
rm -f findomain-linux-i386.zip

# downloading ffuf
cd /$_dir
git clone https://github.com/ffuf/ffuf
cd ffuf
go get
go build
ln -sf $PWD/ffuf $_path/ffuf

# downloading freq
cd /$_dir
git clone https://github.com/takshal/freq
cd freq
go build -o freq main.go
ln -sf $PWD/freq $_path/freq

# downloading gargs
cd /$_dir
curl -OLsk https://github.com/brentp/gargs/releases/download/v0.3.9/gargs_linux
mv $PWD/gargs_linux $_path/gargs

# downloading gau
cd /$_dir
git clone https://github.com/lc/gau
cd gau/cmd/gau
go get
go build
ln -sf $PWD/gau $_path/gau

# downloading gf
cd /$_dir
git clone https://github.com/1ndianl33t/Gf-Patterns /home/$_user/.gf
git clone https://github.com/tomnomnom/gf
cd gf
mv examples/* /home/$_user/.gf/
go build -o gf main.go
ln -sf $PWD/gf $_path/gf

# downloading github-collection-tools
cd /$_dir
git clone https://github.com/gwen001/github-search
cd github-search
printf "$GITHUB_API_TOKEN" >> .tokens
sed s/'\/usr\/bin\/python2'/'\/usr\/bin\/python3'/g git-history.py > a; mv a git-history.py
sed s/'\/usr\/bin\/python2'/'\/usr\/bin\/python3'/g github-contributors.py > a; mv a github-contributors.py
sed s/'\/usr\/bin\/python2'/'\/usr\/bin\/python3'/g github-dorks.py > a; mv a github-dorks.py
rm -f a
for x in $(printf "\n%s" * | grep -E 'sh|py|php');do ln -sf $PWD/$x $_path/$x ; done

# downloading gospider
cd /$_dir
git clone https://github.com/jaeles-project/gospider
cd gospider
go get
go build
ln -sf $PWD/gospider $_path/gospider

# downloading gowitness
cd /$_dir
git clone https://github.com/sensepost/gowitness
cd gowitness
chrome_install # installing chrome ~ arch-based
go get
go build
ln -sf $PWD/gowitness $_path/gowitness

# downloading goop
cd /$_dir
git clone https://github.com/nyancrimew/goop
cd goop
go get
go build
ln -sf $PWD/goop $_path/goop

# downloading getJS
cd /$_dir
su $_user -c 'go install github.com/003random/getJS@latest'

# downloading hakrawler
cd /$_dir
git clone https://github.com/hakluke/hakrawler
cd hakrawler
go get
go build
ln -sf $PWD/hakrawler $_path/hakrawler

# downloading hakrevdns
cd /$_dir
su $_user -c 'go install github.com/hakluke/hakrevdns@latest'

# downloading haktldextract
cd /$_dir
git clone https://github.com/hakluke/haktldextract
cd haktldextract
go get
go build
ln -sf $PWD/haktldextract $_path/haktldextract

# downloading haklistgen
cd /$_dir
su $_user -c 'go install github.com/hakluke/haklistgen@latest'

# downloading html-tool
cd /$_dir
su $_user -c 'go install github.com/tomnomnom/hacks/html-tool@latest'

# downloading httpx
cd /$_dir
git clone https://github.com/projectdiscovery/httpx
cd httpx
make
ln -sf $PWD/httpx $_path/httpx

# downloading jaeles
cd /$_dir
su $_user -c 'go install github.com/jaeles-project/jaeles@latest'

# downloading jsubfinder
cd /$_dir
git clone https://github.com/ThreatUnkown/jsubfinder
cd jsubfinder
go get
go build
ln -sf $PWD/jsubfinder $_path/jsubfinder

# downloading kxss
cd /$_dir
su $_user -c 'go install github.com/Emoe/kxss@latest'

# downloading katana
cd /$_dir
su $_user -c 'go install github.com/projectdiscovery/katana/cmd/katana@latest'

# downloading LinkFinder
cd /$_dir
git clone https://github.com/GerbenJavado/LinkFinder
cd LinkFinder
pip3 install -r requirements.txt
python3 setup.py install
ln -sf $PWD/linkfinder.py $_path/linkfinder.py

# downloading log4j-scan
cd /$_dir
git clone https://github.com/fullhunt/log4j-scan
cd log4j-scan
pip3 install -r requirements.txt
ln -sf $PWD/log4j-scan.py $_path/log4j-scan.py

# downloading metabigor
cd /$_dir
su $_user -c 'go install github.com/j3ssie/metabigor@latest'
printf 'export ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH=go1.19' >> /home/$_user/.zshrc
printf 'export ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH=go1.19' >> /root/.zshrc

# downloading MassDNS
cd /$_dir
git clone https://github.com/blechschmidt/massdns
cd massdns
make
ln -sf $PWD/bin/massdns $_path/massdns

# downloading naabu
cd /$_dir
su $_user -c 'go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest'

# downloading notify
cd /$_dir
su $_user -c 'go install -v github.com/projectdiscovery/notify/cmd/notify@latest'

# downloading ParamSpider
cd /$_dir
git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
pip3 install -r requirements.txt
ln -sf $PWD/paramspider.py $_path/paramspider.py

# downloading qsreplace
cd /$_dir
git clone https://github.com/tomnomnom/qsreplace
cd qsreplace
go get
go build
ln -sf $PWD/qsreplace $_path/qsreplace

# downloading rush
cd /$_dir
su $_user -c 'go install github.com/shenwei356/rush@latest'

# downloading SecretFinder
cd /$_dir
git clone https://github.com/m4ll0k/SecretFinder
cd SecretFinder
pip3 install -r requirements.txt
ln -sf $PWD/SecretFinder.py $_path/SecretFinder.py

# downloading shodan
pacman -S python-shodan --noconfirm
shodan init $SHODAN_API_KEY

# downloading shuffedns
cd /$_dir
su $_user -c 'go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest'

# downloading sqlmap
cd /$_dir
git clone https://github.com/sqlmapproject/sqlmap
cd sqlmap
ln -sf $PWD/sqlmap.py $_path/sqlmap

# downloading subfinder
cd /$_dir
su $_user -c 'go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest'
su user -c 'subfinder'
subfinder
_setAPIs > /home/$_user/.config/subfinder/provider-config.yaml
_setAPIs > /root/.config/subfinder/provider-config.yaml

# downloading SubJS
cd /$_dir
su $_user -c 'go install -v github.com/lc/subjs@latest'

# downloading unew
cd /$_dir
su $_user -c 'go install -v github.com/dwisiswant0/unew@latest'

# downloading unfurl
cd /$_dir
su $_user -c 'go install github.com/tomnomnom/unfurl@latest'

# downloading urldedupe
cd /$_dir
git clone https://github.com/ameenmaali/urldedupe
cd urldedupe
pacman -S cmake clang --noconfirm
cmake CMakeLists.txt
make
ln -sf $PWD/urldedupe $_path/urldedupe

# downloading WaybackUrls
cd /$_dir
su $_user -c 'go install github.com/tomnomnom/waybackurls@latest'

# downloading tojson
cd /$_dir
mkdir tojson
cd tojson
curl -OLsk https://raw.githubusercontent.com/tomnomnom/hacks/master/tojson/main.go
go build -o tojson main.go
ln -sf $PWD/tojson $_path/tojson

# downloading x8
pacman -S cargo --noconfirm
git clone https://github.com/Sh1Yo/x8
cd x8
cargo build --release
ln -sf $PWD/target/release/x8 $_path/x8

# downloading XSStrike
cd /$_dir
git clone https://github.com/s0md3v/XSStrike
cd XSStrike
pip3 install -r requirements.txt
ln -sf $PWD/xsstrike.py $_path/xsstrike.py

# downloading page-fetch
cd /$_dir
su $_user -c 'go install github.com/detectify/page-fetch@latest'

# downloading Axiom
# cd /$_dir
# git clone https://github.com/pry0cc/axiom
# cd axiom/interact
# ./axiom-configure

# Give 0777 permissions to /$_dir binaries
chmod -R 0777 /$_dir

# End
printf "\n\n\e[1;34mWell Done! :)
Total-time: $((`date +%s` - $_init)) seconds
\e[1;34mAll tools have been installed!, Have a lot of Bounties!!
\n\e[0m"
