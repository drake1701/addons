local _, T = ...
if T.Mark ~= 23 then return end

T.Affinities = {} do
	local ht, hp = [[ �K��12I�^��|��Љ�b��,�S�G�Ü�m�3���Y��ղ?V=;����&��X���D	ꅙ襔�J�U�wU��|M��e�r>Ε��&[�ǡ_����F��t��yʜ�{��kh��[��$�b�sb���`�~YMH�ݙzN�Y��&YH�~��d�D�Z>Ռf���>d����P�r6{��*����E6��!d���r��щ�"�$�>�A�"ܴ��>xZB"N!��!�z�3����+!��ćI'J	"&�to҅��B�91ZPD!��)R�P�I�[�'���:N='��i;���ԡ#�gy��6M��հ�9ؔ�){3��a�r9+i�ʈD��&G��H��#�΍k�~4!ȴ��#春[���} ��,aGEl��y�p|�v�'dHH�GD$�J%G�la#�+J��$b�EђB>�s#��r�z1u6�ȸ�(rv�σZt�hb��Qt��+��ú�����bY%���F��V��'#H����DD�%)R$K��9g{��i]�1����0�]], [[(((h((inq(pjgkrso(lm]]
	local p, G, V, Vp, by, hk, ak = {}, 101, 541, 203, ht.byte, UnitFactionGroup('player') == 'Horde' and 15030 or 3110, 55683
	for i=1,#hp do p[i] = by(hp, i) - 40 end
	setmetatable(T.Affinities, {__index=function(t, k)
		local k, c, a, v, r, b, d, e = k or false, k, type(k)
		if a == "string" then
			a, c = "number", tonumber(k:match("^0x0*(%x*)$") or "z", 16) or false
		end
		if a == "number" and c then
			c = c * hk
			a = 2*(((c * ak) % 2147483629) % G)
			a, b = by(ht, a+1, a+2)
			v = ((c * (a*256+b) + ak) % 2147483629) % V
			v, r = Vp + (v - v % 8)*5/8, v % 8
			a, b, c, d, e = by(ht, v, v + 4)
			v = a * 4294967296 + b * 16777216 + c * 65536 + d * 256 + e
			v = ((v - v % 32^r) / 32^r % 32)
		end
		t[k] = p[v] or 0
		return t[k]
	end})
end

T.MissionExpire = {} do
	local expire = T.MissionExpire
	for n, r in ("000210611621id2e56516c16o17i0:0ga6b:0o2103rz4rz5r86136716e26q37ji9549eja23ai1al3aqg:102zd3h86vm82mak0ap0:1y9a39y3:20050100190:9b8pfb7a"):gmatch("(%w%w)(%w+)") do
		local n = tonumber(n, 36)
		for s, l in r:gmatch("(%w%w)(%w)") do
			local s = tonumber(s, 36)
			for i=s, s+tonumber(l, 36) do
				expire[i] = n
			end
		end
	end
end

T.EnvironmentCounters = {[11]=4, [12]=38, [13]=42, [14]=43, [15]=37, [16]=36, [17]=40, [18]=41, [19]=42, [20]=39, [21]=7, [22]=9, [23]=8, [24]=45, [25]=46, [26]=44, [27]=47, [28]=48, [29]=49,}

T.SpecCounters = { nil, {1,2,7,8,10}, {1,4,7,8,10}, {1,2,7,8,10}, {6,7,9,10}, nil, {1,2,6,10}, {1,2,6,9}, {3,4,7,9}, {1,6,7,9,10}, nil, {6,7,8,9,10}, {2,6,7,9,10}, {6,8,9,10}, {6,7,8,9,10}, {2,7,8,9,10}, {1,2,3,6,9}, {3,4,6,8}, {1,6,8,9,10}, {3,4,8,9}, {1,2,4,8,9}, {2,7,8,9,10}, {3,4,6,9}, {3,4,6,7}, {4,6,7,9,10}, {2,6,8,9,10}, {6,7,8,9,10}, {2,6,7,8,9}, {3,7,8,9,10}, {3,6,7,9,10}, {3,4,7,8}, {4,7,8,9,10}, {2,7,8,10,10}, {3,8,9,10,10}, {1,6,7,8,10}, nil, {2,6,7,8,10}, {1,2,6,7,8} }

T.EquivTrait = {[244]=4, }