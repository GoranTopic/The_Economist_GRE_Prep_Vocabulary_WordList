#!/bin/bash 

cp missing_urls.txt missing_urls.working;

# for url in `cat missing_urls.txt`;
# do echo "sleep $(( RANDOM % 5 ));" > /dev/null;

# grep -F -v "$url" temp=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" "$url" );
# image=$(echo $temp |  grep -o '<div itemprop=publisher.*<div class=gre-vocabulary-block-title>' | grep -o -P 'https\://e.*\.png'); 
#wget $image && echo "deleteing $url" && sed -i '1d' urls.txt ; done 


for url in  $( cat missing_urls.working ); do

	if grep -F "$url" done_urls.txt ; then echo "already downloaded" && continue; fi


	#echo "sleeping.."
	#sleep $(( RANDOM % 5 ));

	echo "getting site $url"; 
	website=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" "$url" ); 

	image_url=$(echo $website | grep -o '<div itemprop=publisher.*<div class=gre-vocabulary-block-title>' | grep -o -P 'https\://e.*\.png'); 
	echo "getting image url: $image_url";
		
	if [ -z "$image_url" ]; then  
		echo "no image found";
		echo $url >> no_image_urls.txt;
	else
		wget $image_url && echo "got image" && echo $url >> done_urls.txt;
	fi

done
