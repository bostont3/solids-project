clc,clear,close all
%% Truss No.
FN='boxTruss';
% FN='DATA25';
%% Input Data
TrussData = xlsread(FN,1);
JointNo=TrussData(:,1);
xJoint=TrussData(:,2);              
yJoint=TrussData(:,3);              
zJoint=TrussData(:,4); 
XR=TrussData(:,5);
YR=TrussData(:,6);
ZR=TrussData(:,7);
FX=TrussData(:,8);                    
FY=TrussData(:,9);                  
FZ=TrussData(:,10);                   
ElementNo=TrussData(:,11);
BJ=TrussData(:,12);
EJ=TrussData(:,13);
E=TrussData(:,14);                    
A=TrussData(:,15);                   
[JointNo,ElementNo,xJoint,yJoint,XR,YR,FX,BJ,EJ,E,A,FY,zJoint,ZR,FZ]=...,
    RemovedNan(JointNo,ElementNo,xJoint,yJoint,XR,YR,FX,BJ,EJ,E,A,FY,zJoint,ZR,FZ); %% Removed NaN cell
NJ=max(JointNo);                    %Number of joint 
NElement=max(ElementNo);   %Number of element  
gcords=[xJoint,yJoint,zJoint];
SC=200;%magnifier for undeformd shape
nodeselements=[BJ,EJ];
support=[XR YR ZR];
%% Figures 
disp_Shape='on';
disp_Reactions='on';
disp_Deformed='on';
disp_Stress='on';
disp_OPT={disp_Shape;disp_Reactions;disp_Deformed;disp_Stress};
%% Calculate the length of each element and Calculate Cos 
L=zeros(1,NElement);
cx=zeros(1,NElement);
cy=zeros(1,NElement);
cz=zeros(1,NElement);
for i=1:NElement
L(i)=sqrt(((xJoint(EJ(i))-(xJoint(BJ(i))))^2)+((yJoint(EJ(i))-(yJoint(BJ(i))))^2)+((zJoint(EJ(i))-(zJoint(BJ(i))))^2));%length of element  
cx(1,i)=((xJoint(EJ(i)))-(xJoint(BJ(i))))/L(i);  
cy(1,i)=((yJoint(EJ(i)))-(yJoint(BJ(i))))/L(i);
cz(1,i)=((zJoint(EJ(i)))-(zJoint(BJ(i))))/L(i);
end
%% Create K Matrix
 KMatrix=zeros(3*NJ);
for i=1:NElement
kk=E(i)* A(i) /L(i);
%%% 1 column
KMatrix(3*BJ(i)-2,3*BJ(i)-2)=KMatrix(3*BJ(i)-2,3*BJ(i)-2)+ kk.*cx(i)^2;   %%(3i-2 and 3i-2)
KMatrix(3*BJ(i)-2,3*BJ(i)-1)=KMatrix(3*BJ(i)-2,3*BJ(i)-1)+kk*cx(i)*cy(i);  %%(3i-2 and 3i-1)
KMatrix(3*BJ(i)-2,3*BJ(i))=KMatrix(3*BJ(i)-2,3*BJ(i))+kk*cx(i)*cz(i);        %%(3i-2 and 3i)
KMatrix(3*BJ(i)-2,3*EJ(i)-2)=KMatrix(3*BJ(i)-2,3*EJ(i)-2)- kk.*cx(i)^2;     %%(3i-2 and 3j-2)
KMatrix(3*BJ(i)-2,3*EJ(i)-1)=KMatrix(3*BJ(i)-2,3*EJ(i)-1)-kk*cx(i)*cy(i);    %%(3i-2 and 3j-1)
KMatrix(3*BJ(i)-2,3*EJ(i))=KMatrix(3*BJ(i)-2,3*EJ(i))-kk*cx(i)*cz(i);           %%(3i-2 and 3j)
%%% 2 column
KMatrix(3*BJ(i)-1,3*BJ(i)-2)=KMatrix(3*BJ(i)-1,3*BJ(i)-2)+ kk.*cx(i)*cy(i);   %%(3i-1 and 3i-2)
KMatrix(3*BJ(i)-1,3*BJ(i)-1)=KMatrix(3*BJ(i)-1,3*BJ(i)-1)+kk*cy(i)^2;  %%(3i-1 and 3i-1)
KMatrix(3*BJ(i)-1,3*BJ(i))=KMatrix(3*BJ(i)-1,3*BJ(i))+kk*cy(i)*cz(i);        %%(3i-1 and 3i)
KMatrix(3*BJ(i)-1,3*EJ(i)-2)=KMatrix(3*BJ(i)-1,3*EJ(i)-2)- kk.*cx(i)*cy(i);      %%(3i-1 and 3j-2)
KMatrix(3*BJ(i)-1,3*EJ(i)-1)=KMatrix(3*BJ(i)-1,3*EJ(i)-1)-kk*cy(i)^2;   %%(3i-1 and 3j-1)
KMatrix(3*BJ(i)-1,3*EJ(i))=KMatrix(3*BJ(i)-1,3*EJ(i))-kk*cy(i)*cz(i);         %%(3i-1 and 3j)
%%% 3 column
KMatrix(3*BJ(i),3*BJ(i)-2)=KMatrix(3*BJ(i),3*BJ(i)-2)+ kk.*cx(i)*cz(i);   %%(3i and 3i-2)
KMatrix(3*BJ(i),3*BJ(i)-1)=KMatrix(3*BJ(i),3*BJ(i)-1)+kk*cy(i)*cz(i);  %%(3i and 3i-1)
KMatrix(3*BJ(i),3*BJ(i))=KMatrix(3*BJ(i),3*BJ(i))+kk*cz(i)^2;        %%(3i and 3i)
KMatrix(3*BJ(i),3*EJ(i)-2)=KMatrix(3*BJ(i),3*EJ(i)-2)- kk.*cx(i)*cz(i);      %%(3i and 3j-2)
KMatrix(3*BJ(i),3*EJ(i)-1)=KMatrix(3*BJ(i),3*EJ(i)-1)-kk*cy(i)*cz(i);   %%(3i and 3j-1)
KMatrix(3*BJ(i),3*EJ(i))=KMatrix(3*BJ(i),3*EJ(i))-kk*cz(i)^2;          %%(3i and 3j)
%%% 4 column
KMatrix(3*EJ(i)-2,3*BJ(i)-2)=KMatrix(3*EJ(i)-2,3*BJ(i)-2)- kk.*cx(i)^2;   %%(3j-2 and 3i-2)
KMatrix(3*EJ(i)-2,3*BJ(i)-1)=KMatrix(3*EJ(i)-2,3*BJ(i)-1)-kk*cx(i)*cy(i);  %%(3j-2 and 3i-1)
KMatrix(3*EJ(i)-2,3*BJ(i))=KMatrix(3*EJ(i)-2,3*BJ(i))-kk*cx(i)*cz(i);        %%(3j-2 and 3i)
KMatrix(3*EJ(i)-2,3*EJ(i)-2)=KMatrix(3*EJ(i)-2,3*EJ(i)-2)+ kk.*cx(i)^2;     %%(3j-2 and 3j-2)
KMatrix(3*EJ(i)-2,3*EJ(i)-1)=KMatrix(3*EJ(i)-2,3*EJ(i)-1)+kk*cx(i)*cy(i);    %%(3j-2 and 3j-1)
KMatrix(3*EJ(i)-2,3*EJ(i))=KMatrix(3*EJ(i)-2,3*EJ(i))+kk*cx(i)*cz(i);           %%(3j-2 and 3j)
%%% 5 column
KMatrix(3*EJ(i)-1,3*BJ(i)-2)=KMatrix(3*EJ(i)-1,3*BJ(i)-2)- kk.*cx(i)*cy(i);   %%(3j-1 and 3i-2)
KMatrix(3*EJ(i)-1,3*BJ(i)-1)=KMatrix(3*EJ(i)-1,3*BJ(i)-1)-kk*cy(i)^2;  %%(3j-1 and 3i-1)
KMatrix(3*EJ(i)-1,3*BJ(i))=KMatrix(3*EJ(i)-1,3*BJ(i))-kk*cy(i)*cz(i);        %%(3j-1 and 3i)
KMatrix(3*EJ(i)-1,3*EJ(i)-2)=KMatrix(3*EJ(i)-1,3*EJ(i)-2)+kk.*cx(i)*cy(i);      %%(3j-1 and 3j-2)
KMatrix(3*EJ(i)-1,3*EJ(i)-1)=KMatrix(3*EJ(i)-1,3*EJ(i)-1)+kk*cy(i)^2;   %%(3j-1 and 3j-1)
KMatrix(3*EJ(i)-1,3*EJ(i))=KMatrix(3*EJ(i)-1,3*EJ(i))+kk*cy(i)*cz(i);         %%(3j-1 and 3j)
%%% 6 column
KMatrix(3*EJ(i),3*BJ(i)-2)=KMatrix(3*EJ(i),3*BJ(i)-2)- kk.*cx(i)*cz(i);   %%(3j and 3i-2)
KMatrix(3*EJ(i),3*BJ(i)-1)=KMatrix(3*EJ(i),3*BJ(i)-1)-kk*cy(i)*cz(i);     %%(3j and 3i-1)
KMatrix(3*EJ(i),3*BJ(i))=KMatrix(3*EJ(i),3*BJ(i))-kk*cz(i)^2;               %%(3j and 3i)
KMatrix(3*EJ(i),3*EJ(i)-2)=KMatrix(3*EJ(i),3*EJ(i)-2)+ kk.*cx(i)*cz(i);   %%(3j and 3j-2)
KMatrix(3*EJ(i),3*EJ(i)-1)=KMatrix(3*EJ(i),3*EJ(i)-1)+kk*cy(i)*cz(i);     %%(3j and 3j-1)
KMatrix(3*EJ(i),3*EJ(i))=KMatrix(3*EJ(i),3*EJ(i))+kk*cz(i)^2;                %%(3j and 3j)
end
  %% Create load vector
   
load=zeros(3*NJ,1);
for i=1:NJ
        if FX(i)~=0
            load(3*i-2,1)=FX(i);
        end
        if FY(i)~=0
            load(3*i-1,1)=FY(i);
        end
        if FZ(i)~=0
            load(3*i,1)=FZ(i);
        end
end
   
%% Finding the Displacement for each joint
BigNumber=2e15;
KMatrix2=KMatrix;
for i=1:NJ
    if  XR(i)==1
        KMatrix2(3*i-2,3*i-2)=KMatrix(3*i-2,3*i-2)+BigNumber;
    end
    if  YR(i)==1
        KMatrix2(3*i-1,3*i-1)=KMatrix(3*i-1,3*i-1)+BigNumber;
    end
    if  ZR(i)==1
        KMatrix2(3*i,3*i)=KMatrix(3*i,3*i)+BigNumber;
    end
end
Disp=KMatrix2\load;
JointDisp=zeros(3*NJ,1);
for i=1:3*NJ
    if abs(Disp(i,1))<1e-10
        JointDisp(i,1)=0;
    else 
        JointDisp(i,1)=Disp(i,1);
    end
end
for i=1:NJ
    X_JD(i,1)=(JointDisp(3*i-2));
    Y_JD(i,1)=(JointDisp(3*i-1));
    Z_JD(i,1)=(JointDisp(3*i));
end
    X_JD;Y_JD;Z_JD;
   W=[X_JD  Y_JD Z_JD];
%% Finding Stress in Each element and Support reactions
Stress=zeros(NElement,1);
for i=1:NElement
    Stress(i,1)=(E(i)/L(i))*(-cx(i)*JointDisp(3*BJ(i)-2)-cy(i)*JointDisp(3*BJ(i)-1)-cz(i)*JointDisp(3*BJ(i))+cx(i)*JointDisp(3*EJ(i)-2)+cy(i)*JointDisp(3*EJ(i)-1)+cz(i)*JointDisp(3*EJ(i)));
end
R=KMatrix*JointDisp;%Support reactions
for i=1:3*NJ
    if abs(R(i,1))<1e-5
        R(i,1)=0;
    else
        R(i,1)=R(i,1);
    end
end
%% Write Microsoft Excel spreadsheet result
xlswrite([strcat('Results3D ',num2str(FN)),datestr(now,' HH-MM '),'.xlsx'],load,1,'A2');
xlswrite([strcat('Results3D ',num2str(FN)),datestr(now,' HH-MM '),'.xlsx'],JointDisp,1,'B2');
xlswrite([strcat('Results3D ',num2str(FN)),datestr(now,' HH-MM '),'.xlsx'],Stress,1,'C2');
xlswrite([strcat('Results3D ',num2str(FN)),datestr(now,' HH-MM '),'.xlsx'],R,1,'D2');
%% Truss Shape
PlotResults(NElement,gcords,nodeselements,NJ,W,load,R,Stress,support,SC,disp_OPT)
%% finish