if GetLocale() ~= "koKR" then return end
if (UnitFactionGroup("player") == "Alliance" and 1 or 2) ~= 2 then return end

table.insert(QHDB, {
		flightmasters = {
		"&��Rg�v��KP�",
		[3] = "	�y)�j�}h�5$�j�Z�C�I",
		[4] = ",���izOQH	 ",
		[5] = "�4����͍ �Y��]%�V�$�",
		[6] = "	A�	��pM�v�P>2��?H",
		[8] = "	�9���8P��F�]�A��\000BH",
		[9] = "p�-ˉ���	PD�l$�",
		[10] = "\r��1��r;����$",
		[11] = "�*V\000�",
		[13] = "�r�)U�c�4_�H���@",
		[14] = "� Xڮ�]�Bk#J��",
		[15] = "����XOA�\000!$",
		[17] = "	A�	��BX�i�U����",
		[19] = "J�MD��N��	 ",
		[22] = "ɾ}5{b�x�@�\000��",
		[24] = "�٧tw��F[��0�",
		[26] = "Du�9�1>B+�tIi����8��;�\000$�",
		[28] = "��#�r*���8�~�",
		[29] = "������1&����[BH",
		[31] = "��R'�4�L���}�=��?H",
		[32] = "A����F8�	 ",
		[33] = "\r�Miø�h,�s`��/*��",
		[35] = "&9	����1&�dc�P�",
		[36] = "���\000@",
		[38] = "���Xb�^�ܯ$�;B3<��I",
		[41] = "1��z�y���m%G5b�@",
		[43] = "��:��=��{;����H",
		[45] = "\
_(0F���M��5�j>\000BH",
		[48] = "�8�|@��h�V~�",
		[49] = "v:�\rJ��ߞ�����d��I",
		[50] = "\
�����qR�x@n~�",
		[51] = "*��	�<܌��.·�P�c$�\000!$",
		[52] = "�tR�?e�-���k��5\000I",
		[53] = "�>�*��[���	=D �",
		[54] = "��ܯ$J��tf�U����",
		[55] = "\r�T}zh�y�cs6X@8�PG�	 ",
		[57] = "�| �9^�]���k�'���I",
		[58] = "9G-s���ci*9�В",
		[59] = "���ƵvU���g�$",
		[61] = "��$M҈��q�~�l>�xd�H",
		[62] = "\r�ѓ��\000�+د�)��",
		[63] = "\"\
@��^���	 ",
		[64] = "fE�C�N��	 ",
		[65] = "L�(/b�c�\r<%�xO��",
		[68] = "\
�B��Y�Ma�X\"��6���H",
		[69] = "m�[�\";��[��0�",
		[70] = "�E�i��i�bZ#�&9R8����$",
		[71] = "���7���{�H�a�3�&@",
		[73] = "��ä����Tu��`�g�/\"I",
		[75] = "!�$W����z��\000��",
		[77] = "P��/�\000!$",
		[81] = "�b�RKŪ��$�",
		[83] = "�ނ������e�\r���",
		[84] = "*u��rj�FH�O��",
		[85] = "�n�3�� I",
		[86] = "	�6���5�!E�B~�",
		[87] = "9RA}VRJtGz��<'�I",
		[88] = "�e�G�ң�h�V~�",
		[89] = ".D�\
v��{AU��ה�+g�I",
		[91] = "C�_�Or��h����\000!$",
		[92] = "��=�vo\\yu�Fu@��@",
		[95] = "	RBũ�ꑖ��g�L$�",
		[96] = "�.ó	̆W�&��k��5\000I",
		[97] = "	Mh��V�*���R$",
		[98] = "*u��r���&���TfVςH",
		[99] = "\
��i��r;�s4��#��-?@I",
		[103] = "F)�=��^AL���~�",
		[105] = "��PD�A�]?�T$�",
		[106] = "&��Rg�v�H1���,�A�>	 ",
		[107] = "����[����$",
		[109] = "I{�ɬv�e|Hoy2O��",
		[112] = "z)�X���4_�H���@",
		[113] = "O��b]�T��$",
		[114] = "�jX&5����#g��>�@",
		[116] = "FZ�(e�Nk�;����[BH",
		[117] = "�&���w�i�/C�~�",
		[118] = "����",
		[119] = "\
tRDQ��Pj�[κHΨ?H",
		[121] = "m�b�X���+|^�a'��@",
		[123] = "d9@��S6R���<ع�@",
		[126] = "T �\000Ntڃ]O2\000��",
		__dictionary = " \"(),3=Kaemn�������������������������������������������������������������",
		__tokens = ",@�!����`!%͟FB�kٝ@Wop��p��6�F,�~�LHu�I@�\\Y�Q���@�_�ߖ���P#\000Q��%�N#ؤ���ɨ�Q��(�K���hō���ݑ�f��ьD�+��M���q�IN,	(��l53T�,\
%��w���a!�\"�h�g����Q��w�{W<�����-��d�:Q����b\000\000��S<�>��'1@�H�\000�8��#{��`�0EBeb�`1�\000a���s~\000�(c�\
G	��hd8�/\000(ԃ��F\
����t% L�hgb{�!W�)�lF,�耆&���L#�p�\000a\
R奁�L��H��	��@�,�\"�\000�F�U<F�!�9!�����	�8X�F��\"�|���D�=h�NS�Π%�кs'!0xO}�]������g������I[\"����y��(�H 0��s��:�@5��r���F�'	s��1����y��	�Ёa{�HIo0Z�Š��_�фML�i��� �$`�Y��p5Ks�p��ŀh6F�m� a&K�����\000�f�T �'f��u���H#��H��҇F �X�5����U$�*O�-(��o���!;\000��eed#�	w1`g#��HfP5|�&�Gx�C0i�u�m��+V�!�k��C����x\\P@H\
\r$,h��y����]7�g�&�j5�T\000�7���4vj��;�M���X�����Q���*6BT%Hl�k�^*~�UI�V��~!��B�(aq�J�@ZV��)��`�5m�oR�Ra\000��w��|>'��1�R� �`��ԗ�f_����ɷ�E�|1p�aꔑ���\000�	F��\000Q���3�\000Al�\\�!\rdԓ�2E�ڗ)���a�HA�E+(�`T��P�2X����4:�Qx�O�@��7�h�$�a E_��a�G�(xa3���h$�a`��\
�&j�e����@�<���|X\
��LL6����S����XD&�ba�mЭ�C�U��]ԜRR��\
�#΢�v/�@+��¡���+��%䡅���n�Xs$��rT�P�\"�lGneai\
�Q�U�(�\000M�8�H�dF���h\000d���`+@A��M�<|��o��|\000%iM�,�R�u`ŭ�$X�`b�փ�.\000M��e��D8��)���� �RD\
?\r�+���Tk�~��B�/_|��w��=�8���������y�:4�a��X8q4\"�A2�h�oGݽ�h[\000<��XH�K�e@Ȓ>�r�g�,w�z��X�X\000��vU[z[ð	������a�\r��h�9�ib��dLI�R�\" A1���1�\\��\"�Ϩ�9)HWڙ��b���<!��*��e���D��~����4�����H����re �2����'��+#�#�A}�&�huW�n�ѢA��Q	��n��+x����wJ�˰RV���$,�@�ɩ�e�h$�,\000�7Vl�.��_�\\L��T�@���X~�4�������h��RqW+ѓf��Xxh��9�\\\
��M��ȣAY1,-�����_��쌡(��Y<��U.�e�W�v�c�4(IK��'-��W	�\000�9b�,�a\000��\000���hU�����	'(+�Q����k�``�0��\000��,AdhAPi`�$1c�*�,��f\
>p�͌Q�\
��s��K՜5ѼA٨ �@�8��46b����>��I�	OY�����\000}��!��` �н�`�4����Z�Ճ����k*\rL�d\r��HX�}�v�o�@���Ժ\r���FRF�xa��`�r*�\r#�r$1��Z�Q@\rۋ$ha[ @���&�ИQ*��:J�F�jnRth�Tm�F�.�F!��T ��b�#2��%�g\000�\
�Sm�c�!8�T�i��3cz�\000��be����ߣ�F�h��TS\rF�(�ф�`�E\
��FT�3KL	#��y��pm��k\000��<	\r�X���Z���z5�����h@�Z!��\000n���[�l�p.A�4��K��h�e�*��-�\000M�q�\r���Ƣ(��F��gEۭ�`�M�o�h��hA ��\r���L�5kH����뒠�p#>�X�41�0Ɓq�c��U��cB�n)�*Ɓa��a`�pE.@���������	�*�����+9�Y���LA�k	L#��>�f<o\
/�	ē���Hi`���H��*4=��	�8� �U�\000����p���	��%���닃�8>��M�&:uF��M����\
�FuD�} 1Q�2��W���`�\000)p[�;.l0���r}�	��]P��	4�d�\\0�׀�b;|�\000���;d���J4`x�@�7D�>s�A�\
4(�F;\000X�t@<����$M�Aq\rR��Bd^D����@�M��@DtA("
	}
}
)
