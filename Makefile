URL=http://lab.hakim.se/reveal-js
REPO=https://github.com/hakimel/reveal.js/archive/master.zip
THEME=openhack
FLAGS=-s \
	  -f rst -t revealjs \
	  --slide-level=2 \
	  -V revealjs-url=./reveal.js \
	  -V theme=${THEME} \
	  -V slideNumber=true \
	  --no-highlight \
	  --mathjax

#D2FILES=$(wildcard d2/*.d2)
D2FILES=d2/mom6code.d2 d2/mom6code_v2.d2
D2FIGURES=$(patsubst %.d2,%.svg,$(subst d2/,img/,$(D2FILES)))

SOURCE=$(wildcard src/*.F90)

all: index.html day2.html day3.html day4.html reveal.js $(D2FIGURES)

reveal.js:
	wget -N ${REPO}
	unzip master.zip
	mv reveal.js-master reveal.js

reveal.js/css/theme/openhack.css: openhack.css
	mkdir -p reveal.js/css/theme
	cp openhack.css reveal.js/css/theme/

index.html: slides.txt openhack.revealjs reveal.js/css/theme/openhack.css $(D2FIGURES) $(SOURCE)
	pandoc ${FLAGS} --template=openhack.revealjs $< -o $@
	sed -i 's/^" data-start-line=/"><code data-start-line=/g' $@
	#sed -i 's/^"><code>/">/g' $@
	sed -i 's/<li class="fragment"/<li/g' $@
	sed -i 's/<video /<video autoplay loop /g' $@

day4.html: day4.txt openhack.notes.revealjs reveal.js/css/theme/openhack.css $(D2FIGURES) $(SOURCE)
	pandoc ${FLAGS} --template=openhack.notes.revealjs $< -o $@
	sed -i 's/^" data-start-line=/"><code data-start-line=/g' $@
	#sed -i 's/^"><code>/">/g' $@
	sed -i 's/<li class="fragment"/<li/g' $@
	sed -i 's/<video /<video autoplay loop /g' $@

img/%.svg: d2/%.d2
	d2 $^ $@ --pad 2

clean:
	rm -f index.html day2.html
	rm -f $(D2FIGURES)
