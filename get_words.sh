#!/bin/bash 

#set delimeter
D=" : ";


for url in  $( cat urls.txt ); do

	if grep -F "$url" done_urls.txt ; then echo "already downloaded" && continue; fi

	#echo "sleeping.."
	#sleep $(( RANDOM % 5 ));

	echo "getting site... $url"; 
	website=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" "$url" ); 


	word_block=$( echo $website | grep -o '<div itemprop=publisher.*<div class=gre-vocabulary-block-title>' ); 
	echo "Word block info gotten... ";
		
	[ -z "$word_block" ] && echo " word error: $word_block" && echo "skipping block" && echo $url >> error_urls.txt;

	echo "get word";
	line=$( echo $word_block | grep -o -E 'itemprop=headline>.+?</h1>' | cut -d\> -f2 | cut -d\< -f1 )$D; 

	echo "get passage";
	line+=$( echo $word_block | grep -o -E 'passage>.*<em>.*</em>[^<]+</div>' | sed 's#<[/]*em>##g' | cut -d\> -f2 | cut -d\< -f1 )$D;

	echo "get pronunciation";
  line+=$( echo $word_block | grep -o -P 'pronunciation>[^<]*<' | cut -d\> -f2 | cut -d\< -f1 )$D;

	echo "get definition";
  line+=$( echo $word_block | grep -o -P 'definition>[^<]*<' | cut -d\> -f2 | cut -d\< -f1 )$D ;

	echo "get synoyms";
	line+=$( echo $word_block | grep -o -P 'synonyms>[^<]*<' | cut -d\> -f2 | cut -d\< -f1 )$D;

	echo "get source ";
	line+=$( echo $word_block | grep -o -P 'Source.*target' | sed 's#<a href=##g' | cut -d' ' -f2 ); 

	echo "getting date";
	line+=$( echo $word_block | grep -o -P 'datetime=[^ ]* ' | cut -d= -f2 )$D ;

	echo "done with word";
	echo "$line" >> words_Ec.txt;
	echo "$url" >> done_urls.txt;

done 

