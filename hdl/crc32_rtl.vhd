------------------------------------------------------------------------------
-- Copyright (C) 2009 OutputLogic.com
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains the original copyright notice
-- and the associated disclaimer.
--
-- THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED	
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
-------------------------------------------------------------------------------
-- CRC module for data(31:0)
--   lfsr(31:0)=1+x^1+x^2+x^4+x^5+x^7+x^8+x^10+x^11+x^12+x^16+x^22+x^23+x^26+x^32;
-------------------------------------------------------------------------------
--Generated via: http://outputlogic.com/?page_id=321

library ieee;
use ieee.std_logic_1164.all;

entity crc32_logic is
   port
   (
      clk                         : in    std_logic;
      rst                         : in    std_logic;
      crc_en                      : in    std_logic;
      data_in                     : in    std_logic_vector(31 downto  0);
      crc_out                     : out   std_logic_vector(31 downto  0)
   );
end crc32_logic;

architecture behavioral of crc32_logic is	

   signal   lfsr_c                : std_logic_vector (31 downto  0);
   signal   lfsr_q                : std_logic_vector (31 downto  0);

begin

   lfsr_c( 0) <= lfsr_q( 0) xor lfsr_q( 6) xor lfsr_q( 9) xor lfsr_q(10) xor lfsr_q(12) xor lfsr_q(16) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor data_in(0) xor data_in(6) xor data_in(9) xor data_in(10) xor data_in(12) xor data_in(16) xor data_in(24) xor data_in(25) xor data_in(26) xor data_in(28) xor data_in(29) xor data_in(30) xor data_in(31);
   lfsr_c( 1) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 6) xor lfsr_q( 7) xor lfsr_q( 9) xor lfsr_q(11) xor lfsr_q(12) xor lfsr_q(13) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(24) xor lfsr_q(27) xor lfsr_q(28) xor data_in(0) xor data_in(1) xor data_in(6) xor data_in(7) xor data_in(9) xor data_in(11) xor data_in(12) xor data_in(13) xor data_in(16) xor data_in(17) xor data_in(24) xor data_in(27) xor data_in(28);
   lfsr_c( 2) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 6) xor lfsr_q( 7) xor lfsr_q(8) xor lfsr_q(9) xor lfsr_q(13) xor lfsr_q(14) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(30) xor lfsr_q(31) xor data_in(0) xor data_in(1) xor data_in(2) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(13) xor data_in(14) xor data_in(16) xor data_in(17) xor data_in(18) xor data_in(24) xor data_in(26) xor data_in(30) xor data_in(31);
   lfsr_c( 3) <= lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 7) xor lfsr_q( 8) xor lfsr_q(9) xor lfsr_q(10) xor lfsr_q(14) xor lfsr_q(15) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(31) xor data_in(1) xor data_in(2) xor data_in(3) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10) xor data_in(14) xor data_in(15) xor data_in(17) xor data_in(18) xor data_in(19) xor data_in(25) xor data_in(27) xor data_in(31);
   lfsr_c( 4) <= lfsr_q( 0) xor lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 6) xor lfsr_q(8) xor lfsr_q(11) xor lfsr_q(12) xor lfsr_q(15) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor data_in(0) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(8) xor data_in(11) xor data_in(12) xor data_in(15) xor data_in(18) xor data_in(19) xor data_in(20) xor data_in(24) xor data_in(25) xor data_in(29) xor data_in(30) xor data_in(31);
   lfsr_c( 5) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q(6) xor lfsr_q(7) xor lfsr_q(10) xor lfsr_q(13) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(24) xor lfsr_q(28) xor lfsr_q(29) xor data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(10) xor data_in(13) xor data_in(19) xor data_in(20) xor data_in(21) xor data_in(24) xor data_in(28) xor data_in(29);
   lfsr_c( 6) <= lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q( 6) xor lfsr_q(7) xor lfsr_q(8) xor lfsr_q(11) xor lfsr_q(14) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(25) xor lfsr_q(29) xor lfsr_q(30) xor data_in(1) xor data_in(2) xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(11) xor data_in(14) xor data_in(20) xor data_in(21) xor data_in(22) xor data_in(25) xor data_in(29) xor data_in(30);
   lfsr_c( 7) <= lfsr_q( 0) xor lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 5) xor lfsr_q( 7) xor lfsr_q(8) xor lfsr_q(10) xor lfsr_q(15) xor lfsr_q(16) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(28) xor lfsr_q(29) xor data_in(0) xor data_in(2) xor data_in(3) xor data_in(5) xor data_in(7) xor data_in(8) xor data_in(10) xor data_in(15) xor data_in(16) xor data_in(21) xor data_in(22) xor data_in(23) xor data_in(24) xor data_in(25) xor data_in(28) xor data_in(29);
   lfsr_c( 8) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 8) xor lfsr_q(10) xor lfsr_q(11) xor lfsr_q(12) xor lfsr_q(17) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(28) xor lfsr_q(31) xor data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(8) xor data_in(10) xor data_in(11) xor data_in(12) xor data_in(17) xor data_in(22) xor data_in(23) xor data_in(28) xor data_in(31);
   lfsr_c( 9) <= lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q( 9) xor lfsr_q(11) xor lfsr_q(12) xor lfsr_q(13) xor lfsr_q(18) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(29) xor data_in(1) xor data_in(2) xor data_in(4) xor data_in(5) xor data_in(9) xor data_in(11) xor data_in(12) xor data_in(13) xor data_in(18) xor data_in(23) xor data_in(24) xor data_in(29);
   lfsr_c(10) <= lfsr_q( 0) xor lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 5) xor lfsr_q( 9) xor lfsr_q(13) xor lfsr_q(14) xor lfsr_q(16) xor lfsr_q(19) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(31) xor data_in(0) xor data_in(2) xor data_in(3) xor data_in(5) xor data_in(9) xor data_in(13) xor data_in(14) xor data_in(16) xor data_in(19) xor data_in(26) xor data_in(28) xor data_in(29) xor data_in(31);
   lfsr_c(11) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 9) xor lfsr_q(12) xor lfsr_q(14) xor lfsr_q(15) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(20) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(31) xor data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(9) xor data_in(12) xor data_in(14) xor data_in(15) xor data_in(16) xor data_in(17) xor data_in(20) xor data_in(24) xor data_in(25) xor data_in(26) xor data_in(27) xor data_in(28) xor data_in(31);
   lfsr_c(12) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q(6) xor lfsr_q(9) xor lfsr_q(12) xor lfsr_q(13) xor lfsr_q(15) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(21) xor lfsr_q(24) xor lfsr_q(27) xor lfsr_q(30) xor lfsr_q(31) xor data_in(0) xor data_in(1) xor data_in(2) xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(9) xor data_in(12) xor data_in(13) xor data_in(15) xor data_in(17) xor data_in(18) xor data_in(21) xor data_in(24) xor data_in(27) xor data_in(30) xor data_in(31);
   lfsr_c(13) <= lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 5) xor lfsr_q( 6) xor lfsr_q(7) xor lfsr_q(10) xor lfsr_q(13) xor lfsr_q(14) xor lfsr_q(16) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(22) xor lfsr_q(25) xor lfsr_q(28) xor lfsr_q(31) xor data_in(1) xor data_in(2) xor data_in(3) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(10) xor data_in(13) xor data_in(14) xor data_in(16) xor data_in(18) xor data_in(19) xor data_in(22) xor data_in(25) xor data_in(28) xor data_in(31);
   lfsr_c(14) <= lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 6) xor lfsr_q( 7) xor lfsr_q(8) xor lfsr_q(11) xor lfsr_q(14) xor lfsr_q(15) xor lfsr_q(17) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(23) xor lfsr_q(26) xor lfsr_q(29) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(11) xor data_in(14) xor data_in(15) xor data_in(17) xor data_in(19) xor data_in(20) xor data_in(23) xor data_in(26) xor data_in(29);
   lfsr_c(15) <= lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q( 7) xor lfsr_q( 8) xor lfsr_q(9) xor lfsr_q(12) xor lfsr_q(15) xor lfsr_q(16) xor lfsr_q(18) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(24) xor lfsr_q(27) xor lfsr_q(30) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(12) xor data_in(15) xor data_in(16) xor data_in(18) xor data_in(20) xor data_in(21) xor data_in(24) xor data_in(27) xor data_in(30);
   lfsr_c(16) <= lfsr_q( 0) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q( 8) xor lfsr_q(12) xor lfsr_q(13) xor lfsr_q(17) xor lfsr_q(19) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(29) xor lfsr_q(30) xor data_in(0) xor data_in(4) xor data_in(5) xor data_in(8) xor data_in(12) xor data_in(13) xor data_in(17) xor data_in(19) xor data_in(21) xor data_in(22) xor data_in(24) xor data_in(26) xor data_in(29) xor data_in(30);
   lfsr_c(17) <= lfsr_q( 1) xor lfsr_q( 5) xor lfsr_q( 6) xor lfsr_q( 9) xor lfsr_q(13) xor lfsr_q(14) xor lfsr_q(18) xor lfsr_q(20) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(30) xor lfsr_q(31) xor data_in(1) xor data_in(5) xor data_in(6) xor data_in(9) xor data_in(13) xor data_in(14) xor data_in(18) xor data_in(20) xor data_in(22) xor data_in(23) xor data_in(25) xor data_in(27) xor data_in(30) xor data_in(31);
   lfsr_c(18) <= lfsr_q( 2) xor lfsr_q( 6) xor lfsr_q( 7) xor lfsr_q(10) xor lfsr_q(14) xor lfsr_q(15) xor lfsr_q(19) xor lfsr_q(21) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(31) xor data_in(2) xor data_in(6) xor data_in(7) xor data_in(10) xor data_in(14) xor data_in(15) xor data_in(19) xor data_in(21) xor data_in(23) xor data_in(24) xor data_in(26) xor data_in(28) xor data_in(31);
   lfsr_c(19) <= lfsr_q( 3) xor lfsr_q( 7) xor lfsr_q( 8) xor lfsr_q(11) xor lfsr_q(15) xor lfsr_q(16) xor lfsr_q(20) xor lfsr_q(22) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(29) xor data_in(3) xor data_in(7) xor data_in(8) xor data_in(11) xor data_in(15) xor data_in(16) xor data_in(20) xor data_in(22) xor data_in(24) xor data_in(25) xor data_in(27) xor data_in(29);
   lfsr_c(20) <= lfsr_q( 4) xor lfsr_q( 8) xor lfsr_q( 9) xor lfsr_q(12) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(21) xor lfsr_q(23) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(30) xor data_in(4) xor data_in(8) xor data_in(9) xor data_in(12) xor data_in(16) xor data_in(17) xor data_in(21) xor data_in(23) xor data_in(25) xor data_in(26) xor data_in(28) xor data_in(30);
   lfsr_c(21) <= lfsr_q( 5) xor lfsr_q( 9) xor lfsr_q(10) xor lfsr_q(13) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(22) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor lfsr_q(31) xor data_in(5) xor data_in(9) xor data_in(10) xor data_in(13) xor data_in(17) xor data_in(18) xor data_in(22) xor data_in(24) xor data_in(26) xor data_in(27) xor data_in(29) xor data_in(31);
   lfsr_c(22) <= lfsr_q( 0) xor lfsr_q( 9) xor lfsr_q(11) xor lfsr_q(12) xor lfsr_q(14) xor lfsr_q(16) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor lfsr_q(31) xor data_in(0) xor data_in(9) xor data_in(11) xor data_in(12) xor data_in(14) xor data_in(16) xor data_in(18) xor data_in(19) xor data_in(23) xor data_in(24) xor data_in(26) xor data_in(27) xor data_in(29) xor data_in(31);
   lfsr_c(23) <= lfsr_q( 0) xor lfsr_q( 1) xor lfsr_q( 6) xor lfsr_q( 9) xor lfsr_q(13) xor lfsr_q(15) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor lfsr_q(31) xor data_in(0) xor data_in(1) xor data_in(6) xor data_in(9) xor data_in(13) xor data_in(15) xor data_in(16) xor data_in(17) xor data_in(19) xor data_in(20) xor data_in(26) xor data_in(27) xor data_in(29) xor data_in(31);
   lfsr_c(24) <= lfsr_q( 1) xor lfsr_q( 2) xor lfsr_q( 7) xor lfsr_q(10) xor lfsr_q(14) xor lfsr_q(16) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(30) xor data_in(1) xor data_in(2) xor data_in(7) xor data_in(10) xor data_in(14) xor data_in(16) xor data_in(17) xor data_in(18) xor data_in(20) xor data_in(21) xor data_in(27) xor data_in(28) xor data_in(30);
   lfsr_c(25) <= lfsr_q( 2) xor lfsr_q( 3) xor lfsr_q( 8) xor lfsr_q(11) xor lfsr_q(15) xor lfsr_q(17) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(31) xor data_in(2) xor data_in(3) xor data_in(8) xor data_in(11) xor data_in(15) xor data_in(17) xor data_in(18) xor data_in(19) xor data_in(21) xor data_in(22) xor data_in(28) xor data_in(29) xor data_in(31);
   lfsr_c(26) <= lfsr_q( 0) xor lfsr_q( 3) xor lfsr_q( 4) xor lfsr_q( 6) xor lfsr_q(10) xor lfsr_q(18) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(31) xor data_in(0) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(10) xor data_in(18) xor data_in(19) xor data_in(20) xor data_in(22) xor data_in(23) xor data_in(24) xor data_in(25) xor data_in(26) xor data_in(28) xor data_in(31);
   lfsr_c(27) <= lfsr_q( 1) xor lfsr_q( 4) xor lfsr_q( 5) xor lfsr_q( 7) xor lfsr_q(11) xor lfsr_q(19) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor data_in(1) xor data_in(4) xor data_in(5) xor data_in(7) xor data_in(11) xor data_in(19) xor data_in(20) xor data_in(21) xor data_in(23) xor data_in(24) xor data_in(25) xor data_in(26) xor data_in(27) xor data_in(29);
   lfsr_c(28) <= lfsr_q( 2) xor lfsr_q( 5) xor lfsr_q( 6) xor lfsr_q( 8) xor lfsr_q(12) xor lfsr_q(20) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(30) xor data_in(2) xor data_in(5) xor data_in(6) xor data_in(8) xor data_in(12) xor data_in(20) xor data_in(21) xor data_in(22) xor data_in(24) xor data_in(25) xor data_in(26) xor data_in(27) xor data_in(28) xor data_in(30);
   lfsr_c(29) <= lfsr_q( 3) xor lfsr_q( 6) xor lfsr_q( 7) xor lfsr_q( 9) xor lfsr_q(13) xor lfsr_q(21) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(31) xor data_in(3) xor data_in(6) xor data_in(7) xor data_in(9) xor data_in(13) xor data_in(21) xor data_in(22) xor data_in(23) xor data_in(25) xor data_in(26) xor data_in(27) xor data_in(28) xor data_in(29) xor data_in(31);
   lfsr_c(30) <= lfsr_q( 4) xor lfsr_q( 7) xor lfsr_q( 8) xor lfsr_q(10) xor lfsr_q(14) xor lfsr_q(22) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor data_in(4) xor data_in(7) xor data_in(8) xor data_in(10) xor data_in(14) xor data_in(22) xor data_in(23) xor data_in(24) xor data_in(26) xor data_in(27) xor data_in(28) xor data_in(29) xor data_in(30);
   lfsr_c(31) <= lfsr_q( 5) xor lfsr_q( 8) xor lfsr_q( 9) xor lfsr_q(11) xor lfsr_q(15) xor lfsr_q(23) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor data_in(5) xor data_in(8) xor data_in(9) xor data_in(11) xor data_in(15) xor data_in(23) xor data_in(24) xor data_in(25) xor data_in(27) xor data_in(28) xor data_in(29) xor data_in(30) xor data_in(31);

   process (clk) begin
      if rising_edge(clk) then
         if rst = '1' then
            lfsr_q                <= X"FFFF_FFFF";
         else
            if (crc_en = '1') then
               lfsr_q             <= lfsr_c;
            end if;
         end if;
      end if;
   end process;

   crc_out                        <= lfsr_q;

end architecture behavioral;

library ieee;
use ieee.std_logic_1164.all;

library axis_bridge_v1_0_lib;
use axis_bridge_v1_0_lib.all;

--apply changes to fit the Xilinx's CRC32 core behavior
--1. input data is byte-reversed
--2. output checksum is byte-reversed AND inverted
entity crc32_rtl is
   port
   (
      CRCCLK                      : in    std_logic;
      CRCRESET                    : in    std_logic; --reset must be asserted BEFORE first data
      CRCDATAVALID                : in    std_logic;
      CRCIN                       : in    std_logic_vector(31 downto  0);
      CRCOUT                      : out   std_logic_vector(31 downto  0)
);
end crc32_rtl;

architecture wrapper of crc32_rtl is

   --component generated automatically on website Outputlogic.com
   component crc32_logic is
   port
   (
      clk                         : in    std_logic;
      rst                         : in    std_logic;
      crc_en                      : in    std_logic;
      data_in                     : in    std_logic_vector(31 downto  0);
      crc_out                     : out   std_logic_vector(31 downto  0)
   );
   end component crc32_logic;

   -- this function takes each byte in a 32 bit vector, and reverse it.
   -- byte order is not changed.
   -- Example: 0123CDEF => 084C3B7F
   function rev_bytes (vec: in std_logic_vector) return std_logic_vector is
      variable temp               : std_logic_vector(31 downto  0);
   begin
      for i in 0 to 7 loop
         temp( 7 - i)             := vec( i);
         temp(15 - i)             := vec( i +  8);
         temp(23 - i)             := vec( i + 16);
         temp(31 - i)             := vec( i + 24);
      end loop;
      return temp;
   end rev_bytes;

   --signal declarations
   signal   crcin_s               : std_logic_vector(31 downto  0);
   signal   crcout_s              : std_logic_vector(31 downto  0);

begin

   --reverse each byte in input data
   -- (b7 b6 b5 b4 b3 b2 b1 b0) => (b0 b1 b2 b3 b4 b5 b6 b7)
   crcin_s                        <= rev_bytes(CRCIN);

   --instance of the CRC core
   crc32_logic_inst: entity axis_bridge_v1_0_lib.crc32_logic
   port map
   (
      clk                         => CRCCLK,
      rst                         => CRCRESET,
      crc_en                      => CRCDATAVALID,
      data_in                     => crcin_s,
      crc_out                     => crcout_s
   );

   --byte-reverse and invert checksum
   CRCOUT                         <= not rev_bytes(crcout_s);

end architecture;

