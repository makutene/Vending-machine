# Vending-machine
This how I tinkered with a vending machine
I’m quite curious about radiofrequency, and I’ve really enjoyed tinkering with different frequencies and protocols — all of it using the RTL-SDR. So now, I’ll explain how I “broke” (for lack of a better word) the system of a vending machine.

The machine itself has several payment methods: inserting coins, topping up a personal wallet through the brand’s own mobile app, or topping up an NFC tag linked to your user account.

First, I investigated what UID was associated with the tag and what chip it used. This can be done in various ways — there are mobile apps that act as readers, or, in my case, I dusted off the Proxmark3.

The chip turned out to be a MIFARE Ultralight EV1 with a 7-byte UID:
04 C2D3F2 3F6B 81

After doing some research on the NXP chip, here’s how the UID breaks down:
	•	The first byte identifies the manufacturer.
	•	The next four bytes are part of the unique chip number.
	•	The following two bytes are a suffix.
	•	The final byte is a checksum.

After dumping the tag’s memory using Proxmark3, nothing particularly useful (or understandable) showed up. The tag I tested had some balance on it, so I had the idea to simulate it with the Proxmark3 to see if the purchase deduction was tied to the tag’s UID.

It worked — the simulation allowed me to make purchases directly from the Proxmark. The balance was being deducted just as it would from the real tag.

Interestingly, the vending machine didn’t appear to have a SIM card, Wi-Fi, or Ethernet module to connect to the cloud and verify or deduct the balance server-side.

So I asked a couple of colleagues for their tags and dumped them to inspect their UIDs. A pattern quickly emerged:
 04 XXXX F2 3F 6B XX
The first byte was always the same, as were the fourth, fifth, and sixth.
Only 3 bytes were random, giving a space of 256^3 possible combinations.

Testing each one manually was insane, so I decided to create a Bash script to automate the process and try my luck at generating valid UIDs that followed this pattern.

First, I generated a text file with random UIDs sharing the known fixed bytes. Then, I created an array to simulate each one using the Proxmark button.

It was tedious and very much a brute-force approach.

After about 20 minutes, the vending machine display showed a balance belonging to some random person at the company. A bit later, even more valid UIDs started to appear.

Of course, this was done purely for educational purposes — to understand how such a system works. But it does raise concerns: even someone like me, with limited knowledge, could potentially cause trouble for the owner if they had malicious intent.
