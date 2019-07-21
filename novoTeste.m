profile clear;
profile on;

%Parse config file
%parse_sniffer_f;

Signal = struct;

 Signal(1).channel = digital_channel_0;
 Signal(2).channel = digital_channel_1;
 Signal(3).channel = digital_channel_2;
 Signal(4).channel = digital_channel_4;
 Signal(5).channel = digital_channel_5;
 Signal(6).channel = digital_channel_6;
 Signal(7).channel = digital_channel_7;
%Signal(8).channel = digital_channel_7;

 Signal(1).type = 'CC2Arm';
 Signal(2).type = 'CC2Arm';
 Signal(3).type = 'Arm2CC';
 Signal(4).type = 'Arm2SM';
 Signal(5).type = 'SM2Arm';
 Signal(6).type = 'Arm2SM';
 Signal(7).type = 'SM2Arm';
%%Signal(8).type = 'SM2Arm';

 Signal(1).name = 'CC2Arm1';
 Signal(2).name = 'CC2Arm2';
 Signal(3).name = 'Arm2CC';
 Signal(4).name = 'Arm2SM_1';
 Signal(5).name = 'SM2Arm_1';
 Signal(6).name = 'Arm2SM_2';
 Signal(7).name = 'SM2Arm_2';
% %Signal(8).name = 'Canal 2';

 Signal(1).Tbit = 1/(4.8e6);
 Signal(2).Tbit = 1/(4.8e6);
 Signal(3).Tbit = 1/(4.8e6);
 Signal(4).Tbit = 1/(4e6);
 Signal(5).Tbit = 1/(4e6);
 Signal(6).Tbit = 1/(4e6);
 Signal(7).Tbit = 1/(4e6);

 Signal(1).NbitsWithStartBit = 11;
 Signal(2).NbitsWithStartBit = 11;
 Signal(3).NbitsWithStartBit = 28;
 Signal(4).NbitsWithStartBit = 9;
 Signal(5).NbitsWithStartBit = 21;
 Signal(6).NbitsWithStartBit = 9;
 Signal(7).NbitsWithStartBit = 21;
% % Signal(7).NbitsWithStartBit = 27;

 Signal(1).InitialBitState = ~0;
 Signal(2).InitialBitState = ~0;
 Signal(3).InitialBitState = ~0;
 Signal(4).InitialBitState = ~1;
 Signal(5).InitialBitState = ~0;
 Signal(6).InitialBitState = ~0;
 Signal(7).InitialBitState = ~0;

 Signal(1).InitialBitState = ~digital_channel_initial_bitstates(1);
 Signal(2).InitialBitState = ~digital_channel_initial_bitstates(2);
 Signal(3).InitialBitState = ~digital_channel_initial_bitstates(3);
 Signal(4).InitialBitState = ~digital_channel_initial_bitstates(5);
 Signal(5).InitialBitState = ~digital_channel_initial_bitstates(6);
 Signal(6).InitialBitState = ~digital_channel_initial_bitstates(7);
 Signal(7).InitialBitState = ~digital_channel_initial_bitstates(8);
% % Signal(7).InitialBitState = ~0;

 Signal(1).idle = ~0;
 Signal(2).idle = ~0;
 Signal(3).idle = ~0;
 Signal(4).idle = ~0;
 Signal(5).idle = ~0;
 Signal(6).idle = ~0;
 Signal(7).idle = ~0;

strt = load('strt_cfg.mat');
%%strt.strt_cfg = strt_cfg;
sampleRate = digital_sample_rate_hz;

curvePlotterWithPostZoom(Signal,sampleRate,strt);
profile viewer;