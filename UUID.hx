/**
 * UUID.hx, an implementation of a UUID v4 generator
 * Pretty much a verbatim copy of Richard Janicek's uuidFast generator, comments mine
 * -----------------
 * By Lewen Yu
 * Original function copyright (c) 2012 Richard Janicek, http://www.janicek.co
 *
 * The MIT License (MIT) http://www.opensource.org/licenses/mit-license.php
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


/* helpful links to understanding the PRNG and the UUID generator:
 * http://en.wikipedia.org/wiki/Park%E2%80%93Miller_random_number_generator
 * http://en.wikipedia.org/wiki/Mersenne_prime
 * http://en.wikipedia.org/wiki/UUID#Version_4_.28random.29
 */

class UUID {
	private inline static var M31 = 2147483647.0; //Mersenne Prime with exponent 31
	private inline static var MINSTD = 16807.0;   //primitive root modulo M31

	// Linear Congruence PRNG that returns the next int (using the Parker-Millar-Carta algorithm) given a seed.
	private static inline function next( seed : Int ) : Int {
		return (( seed * MINSTD ) % M31 ).int();
	}

	public static function getUuid( ?seed : Int ) {
		if (seed.isNull()) {
			seed = Math.floor( Math.random() * M31 );
		}

		var chars = CHARS,
			uuid = new Array(),
			rnd=0,
			r;

		for (i in 0...36) {
			if (i==8 || i==13 ||  i==18 || i==23) {
				uuid[i] = "-";
			} else if (i==14) {
				uuid[i] = "4";
			} else {
				if (rnd <= 0x02) rnd = 0x2000000 + ( ( seed = seed.next() ).toFloat() * 0x1000000 ).int() | 0;
				r = rnd & 0xf;
				rnd = rnd >> 4;

				//bit magic to turn the 19th char into 8, 9, A or B
				uuid[i] = chars[(i == 19) ? ( ( r & 0x3 ) | 0x8 ) : r];
			}
		}
		return uuid.join("");
	}
}