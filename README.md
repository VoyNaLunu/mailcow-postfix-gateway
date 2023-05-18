# Mailcow Postfix Gateway
## Description:
For old, weak or lacking encryption local MFP and scanners.  
gateway-postfix provides unauthenticated and unencrypted access to mailcow-postfix through gateway-vpn wireguard connection. Requires Router/PC with wireguard support that will serve as local gateway for the device. 


## How to use
> clone repository:    
>> `git clone https://github.com/VoyNaLunu/mailcow-postfix-gateway.git`    
>   
> Move to the new folder:
>> `cd mailcow-postfix-gateway/`   
>
> Copy .env.example to .env and change default values:
>> `cp .env.example .env`
>>
>> `nano .env`
>
> Optional: If you have't generated keypair for the client:
>> run this to generate client keypair:
>>> `docker compose run --rm gateway-vpn`
>>
>> to display the keys run:
>>> `docker compose logs`
>>
>> copy the private key to your client's wireguard configuration and public key to `.env`
>
> Start the containers
>> `docker compose up -d`
>
> To display the public key of gateway-vpn run:
>> `docker compose logs`
>
> To test use telnet on your client
>> `telnet 100.64.0.1 8465`
>>
>> you should see similar output:
>>
>> `Trying 100.64.0.1...`
>>
>> `Connected to 100.64.0.1.`
>>
>> `Escape character is '^]'.`
>>
>> `220 mail.example.com ESMTP Postfix`