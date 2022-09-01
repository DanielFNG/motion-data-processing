function markers = produceStatic(static_trc)

markers = Data(static_trc);

%la_jc = getMidpoint(markers, 'L_Ankle_Med', 'L_Ankle_Lat');
ra_jc = getMidpoint(markers, 'R_Shank_Med', 'R_Shank_Lat');
%lk_jc = getMidpoint(markers, 'L_Knee_Med', 'L_Knee_Lat');
rk_jc = getMidpoint(markers, 'R_Thigh_Med', 'R_Thigh_Lat');
%[rh_jc, lh_jc] = getHJCHarrington(markers);
rh_jc = getHJCHarrington(markers);

%labels = {'LAJC', 'RAJC', 'LHJC', 'RHJC', 'LKJC', 'RKJC'};
%values = [la_jc, ra_jc, lh_jc, rh_jc, lk_jc, rk_jc];
labels = {'RAJC', 'RHJC', 'RKJC'};
values = [ra_jc, rh_jc, rk_jc];

markers.extend(labels, values);
end

