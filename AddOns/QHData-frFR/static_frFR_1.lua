if GetLocale() ~= "frFR" then return end
if (UnitFactionGroup("player") == "Alliance" and 1 or 2) ~= 1 then return end

table.insert(QHDB, {
		flightmasters = {
		"\
�\000l�֞`��9H\000�`", "f�3.���T��#\000", "ţ�[�\"�%���^�", "��P��@\\P׾R#\000", "\
�ȂS}�", "ţ����UA�����", "4i��g��Rd3����\000�", "xy�h������R��B�`",
		[11] = "�Ɓ<f��@F",
		[12] = "� �EM�̤�U�F`",
		[13] = "rȢ$��",
		[14] = "u����k4��\000!",
		[15] = "&��*��",
		[16] = "\rw��w��\000X�Z`",
		[17] = "�J<-E������y/��",
		[18] = "�:�.\000B0",
		[19] = "\
�#Ε�.g��;6`",
		[20] = "#&��֔�6l:\000!",
		[21] = "	\
����RT���",
		[22] = "	��!�2lt4R�#\000",
		[23] = "�;=�]O�+���A`",
		[24] = "���K�N���\000�4\000�`",
		[25] = "\
Av��f��XF",
		[26] = "�;v����Q,W�`*��",
		[27] = "o�^�Q����\rȐ�I'�\000B0",
		[28] = "��v��I&��ց",
		[29] = "@������[��j/��\000B0",
		[30] = "F�D_���.qb�� �",
		[31] = "Ӆ8���^�}��Z����|�F",
		[32] = "[��W�ۜ��M�/3�\"��Ab:Dн�=��",
		[33] = "s�rPe���j�",
		[34] = "|��He��~N	�QZ��sA�M�H#\000",
		[35] = "ZT�]�O2��^������",
		[36] = "*A��rUd�l�",
		[37] = "\
�[���}s`F",
		[38] = "%�o�\r�v3޲�#\000",
		[39] = "K6�\r�\000�ց",
		[40] = "\r�4��p�p���$��6�#��r��",
		[41] = "�����._h�֠.(k�)�",
		[42] = "��y�r�@�3u�#\000",
		[43] = "�ܓ5� ��}�}��&�`",
		[44] = "�Z�e��F�_o�\000�`",
		[45] = "����Mn�(P�<����\rN�\\���!",
		[46] = "��k*pˌ�Q=ԕ�+Ќ",
		[47] = "����28��jM�",
		[48] = "\r)���e*`�",
		[49] = "�\"�.3)0Ucс",
		[50] = "�|���\r���",
		[51] = ">�BZ���K���$��",
		[52] = "\\�B��2��]�ou`",
		[53] = "����	��0",
		[54] = "@������C�nS����",
		[55] = " ���������ُ�ڤL��F",
		[56] = "e�B�>.4��",
		[57] = "\
��7�j�=M]�I�",
		[58] = "E�#B�CIt<��#\000",
		[59] = "��*�M����F",
		[60] = "��8M��P�2\000#\000",
		[61] = "5+��E�2����#\000",
		[63] = "���2mAt׾�IU�sw�0",
		[64] = "\ry��+I�.d F",
		[65] = "�\000���\
S2I\000#\000",
		[67] = "�U����g�XZrH��\000B0",
		[68] = "�uQ��J�0",
		[69] = "�b	*4�f��ϐ�",
		[70] = "m՞5���A����",
		[71] = "�0(ژ�⫽�4#\000",
		[72] = "#.��+O��[�<���\r�l�",
		[73] = "١zU��~��",
		[74] = "�R����A\000�A`",
		[75] = "��GYi=$�E�",
		[76] = "�И�R��*1�#\000",
		[77] = "�\
�?WM@�3u�#\000",
		[78] = "ILb�������\"��",
		[79] = "��cť)�a��",
		[80] = "\rհioX�F",
		[81] = "ર�<ĖZ�O�",
		[82] = "r?\"gr2}�t4R�#\000",
		[83] = "՝Qf4�%p�'s\000��A��0",
		[84] = "�~db��6S�F�z�,� �K�",
		[86] = "{m���6L��",
		[87] = " ��Q�	�\
<�`�- �",
		[88] = "l1��Ňe�D7���`",
		[89] = "���Jx��r��ԕ���x�F",
		[90] = "	�\
M�$���~t$�`H8�F",
		[91] = ".a�h��@F",
		[92] = "�&|K���1�A���0|\000B0",
		[93] = "������V�q܊�����",
		[94] = "\
㒾��O8�\000�ǉ`",
		[95] = "�NՌ��9�́",
		[96] = "��+����\
ŏ�o��$Ќ",
		[97] = "\rJ�ץe���r�#\000",
		[98] = "��ҷ���%7с",
		[99] = "��kX�.8oA��ɧYF���",
		[100] = "$3zkv�B�P�J6�5[KaOu%p\
�#\000",
		[102] = "��T=<�u�hȡ",
		[103] = "	gR�xR��D7���`",
		[104] = "\
C,F)�<h�o�\000�`",
		[105] = "�}�'���l�",
		[106] = "#.�\000�N�0���$��6�#��r��",
		[107] = "2T�ˢ3-V]�	\\j^��",
		[108] = "�Հ�",
		[109] = "��)�[\
{�+�W�",
		[110] = "\
EA1���/�'5@��",
		[111] = "���uF������H#\000",
		[112] = "O�u�5b�ㆇ�",
		[113] = "ŝ��U�|���2#\000",
		[114] = "1�l������UA�����",
		[115] = "�>�\000.\
��\r��m������u�nQ",
		[116] = "�&*#$_�)=ԕ�+Ќ",
		[117] = "\r��^/w�vV�̻�|\000�`",
		[118] = "\
C~,:?4~x�",
		[119] = "�7WHP�",
		[120] = "�~G�T�Fi��",
		[121] = "��Lբ=Ǎx��ր�",
		[122] = "Kze�����,]\"yh��",
		[123] = "\r�4��j����P�*���n�`F",
		[124] = "�,�\
&���",
		[125] = "�a�x}s`F",
		[127] = "\
�N(��*��P\r.B`",
		[128] = "̸�'��z�{#Z��j/��\000B0",
		[129] = "@�۸y�e���r�#\000",
		__dictionary = " \"',-235:=ABCDEFGHJKLMNOPRSTUVZabcdefghijklmnopqrstuvwxyz�������������",
		__tokens = "���bc)p�Aȕ2q�i��^\\�&�d��S�3F�U�e��fE�8�ֲ���(>\000�6FTa�\">U\000��5$�>�9����\0007BZYB6L�J�ZUC<OB�AvNWC(iB�/L�NcBg{g=[B4?]��*Z?p͈F]�gv[���k#���9��;�1O��0�B([B;��\r\r�!��]��S���P�Ppb��\
�ތp`�B}:�0g�&P��pS\r��I��&89����RV8*q\r?]A	��#==\000J��v�ʠ\000i|1����]�\000��@z}��]0Y�*�@\000%��B;�k���\000:��\000�X�3�^�~��/����t����A\000�F0%N;\r��K\000�� ZD�� �{t�h������f�Ӵ62�Xd'V�L\000Aڵ�Ej�wV�kL��E����;كI���\000�^�ٱ��m��0*�=ηhV���9A^XF'-N+&\000��ٷ`.������������`�>��`F�!�8�9A�+8!`\000�`�`�\
�4�Z�/�Q���\r	R�\000@Q����5����A��P��\
�����\000ج++�N��%���a�*0a��˒���bZ�!.��`��-��B�c�ԑ�Tt\000�j+`��,�X��1ۺ������,��Q�(���`H΍KX���� {*�\000Yھ��B���e�a#��M��/��Y �0\000T�eD���&�5�5S�\000������ϔ��:���0D��5�K�x�h}��Αx��;��Z�B��[7��(���x���+��\000!@	b�ɕ[/;�kQ��(���.�[S�w}Ad�?j����~�.�4^�̴0_�Z�T���\"����n5�Y |;>A�EnQ^l	*z�r�(�s`�A��d�c7a����|È�rVk�AvӉ���r�v)�VS>h�\\��`Gk;B0P�X����	�v���6�.��N��t㺞-Ŏ���P�b!l[���@UͶhN�C\\ଂ�@��\0007U�Q!S�28�$�����Z�����v����>�*�%�m�7��M��L�?�ѩgYiK��\"��.h�*�Mo�hzwv\r\"��+_�R�#\"�ێ\rHl�v\\k�.�Dd��_�ue�ׅ`~��CD\\�|f�$.�k�`x\
x3$Q��w��,(\
���`A�S�v��fc�2JzbH���c��� 3e���d����Oq��w\000Wi�d�X�y�x�<갣l��ȱ �P�s:�U�J����3���?/eDq�uY�~�\000Åd֘L��^G\\�$��Z�=5��\"��AQ�8���q�,^������sM���#�d��k+`Q���,�K��%LV�0�i��,F�L ����,r������D192\000\"�_�n4�~gL��#�+<�E�P�rr�\
5RTڒ2r���<dӵE`}y9����٩k��X�(����L�I�G	�&��h�^�evM�g3@��\000X��@9̀d�%I6�+�\\�觗�N�aS�+#sP����fō3B9(� �1\000�3\000�CFs��F�&B^��*�E�Ȑ��H`R0�l����\000\
cg�&ȏ\
ˤ	�)�:X��B-6��(<ۀJ+�m� � @���p������}f���%�\\���ln���,�t	i@3-�*��p\000��	���b�%���	[5W�}[�$��FH�ά0.��\
^�r^@��;0Vp**`�r@Ocxo,ժ±\
������@��6GheF@���@���	_\"�l>/V���k�\r�V�ۮ#�BV<HȠ�T�(��\000D\"����c0�0�\000�]��殐�\
_@��:-�&�9V�V�VvA��,9K��� P\000��U��(��\000�Տ^A�騄�n�����3����1t�aϭr�{\000b	��k��p�\\`��BK��E�\"�S���\000�J�`B+���d�V8*X� Á�ę�j^*�Wϧpo���T	�I�r�P�؉����ų��Գ����2�,\000A� 5e?5���Gh'!��j�Ѓ�ߋ�(Η$��]�%���B�Ԛ2Ơ}�ؽ���EP�/����!��C�E*��Fm��t�'�WŅ�\000��!�J�\000/3��4T�^��KRs������e�.\rX�0(��S��B�xr��l>��^�V������ O�`Q�4��Ss���x-�e���$�&h��<cx��\\;���@RQ\000�\\��5Ǎ��譶'�ek�f�![}���xE��44\"�� SZ�����\000�3�+=|d���,,{[1�\000ݦ\0007$�����\"\"p�VF�H@E���3�	���df�YĖ��Ӫ���\000U������\"�Kԁ�frhΊK��m��C96����K�\r���@`�X-r�u����_No]/\000��	Kw��j���5�b(jػ�FBY�y�\000�L�������\
l� J|oD�\000�HgN��4� �Va���?,@\000'��<�ǈX�>aJ�k�J��lV�$NI�z���aH<�p��>�~`1�|�\"�hF%��aLld(>^D��J\000�U�(\000K���J\000fb턱�2���P�\000F2ÿ\
'�bX/��ώ�Ġ��>\"��[��B'X�0�@�f��T[�b�:M�h�F\"9F\"*�Pz'~��d#.B)�w��?�������*\\�ځ�Z5����b��a~\"�X̯�\
��%��;ao`\000AJLm!* ��M�u�\000�D�:����jl��H$R\
E�a@Ne);	�l�\\���FDb�f�fR`�\
C�4{��n>@bb�n��-�����Ծc�-FB\000�P\000O$\000)�<��\000D�\\CP�(��¦� �с��\"��&��[���/ Q\000V�K��0��<a@\000lP���*\
߬h\
�I�@���\000 \
b0�\000\"�-KD\\�y����/�\000��A@a@\000��&\000D\\VK| ��cF\"%c؆�(¦@j\000$������\000\r���a\
���QX��'FN�	*�Z�I�\000�Q2d��K)���:��\000 \000��r\"�x`|�^z\000�\"�B :b�*��B-p��.��Z*jF��b!�8�����KB�)�����4b 婌�&S\rfB�Ԙ��3E�YC�[�J{�T`�/��X�V%�%��j����m�	\"XX#P��j��@\"��*`v �\"*`8�����qKd(\000þ�@|�)��E�#� �"
	}
}
)
