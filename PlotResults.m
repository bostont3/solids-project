function  PlotResults(NElement,gcords,nodeselements,NJ,W,load,R,Stress,support,SC,disp_opt)
%% Truss Shape
if strcmp(disp_opt{1},'on') %%%Compare strings
    subplot(2,2,1);
    view(3)
    for j=1:NElement
        X=[gcords(nodeselements(j,:),1)];
        Y=[gcords(nodeselements(j,:),2)];
        Z=[gcords(nodeselements(j,:),3)];
        hold on
        plot3(X,Y,Z,'c','linewidth',2)
        plot3(X,Y,Z,'o','linewidth',2)
        grid on
        xlabel('X axis \rightarrow','Color','m')
        ylabel('Y axis \Rightarrow','Color','b')
        zlabel('Z axis \rightarrow','Color','g')
        title('Undeformed Shape')
    end
    for a=1:NJ
        nodes=(num2str(a));
        text(gcords(a,1),gcords(a,2),gcords(a,3),nodes,'Color',[0.95 0.35 0],'VerticalAlignment','bottom','HorizontalAlignment','center')
    end
    %%% support
    Support=sum(support,2);
    for a=1:NJ
        if Support(a)>2
            SUPPORT='\Delta';
        elseif Support(a)==2
            SUPPORT='O';
        elseif Support(a)==0
            SUPPORT= '.';
        end
        SUP={SUPPORT};
        text(gcords(a,1),gcords(a,2),gcords(a,3),SUP,'Color','red','VerticalAlignment','cap','HorizontalAlignment','center')
    end
    %%% load and Direction
    ll=reshape(load,3,NJ);
    for a=1:NJ
        X=gcords(a,:);
        lod=ll(:,a)';
        bar(a,:)=[X lod];
    end
    for a=1:NJ
        X=bar(a,1);
        Y=bar(a,2);
        Z=bar(a,3);
        lodet=bar(a,4:6);
        for loadn=1:3
            LOADE=lodet(loadn);
            str = {LOADE};
            if LOADE~=0
                if loadn==1
                    text(X,Y,Z,str,'Color','m','VerticalAlignment','cap','HorizontalAlignment','left')
                elseif loadn==2
                    text(X,Y,Z,str,'Color','b','VerticalAlignment','bottom','HorizontalAlignment','center')
                elseif loadn==3
                    text(X,Y,Z,str,'Color','g','VerticalAlignment','top','HorizontalAlignment','right')
                end
            end
        end
    end
    for b=1:NElement
        Xe=[gcords(nodeselements(b,:),1)];
        Ye=[gcords(nodeselements(b,:),2)];
        Ze=[gcords(nodeselements(b,:),3)];
        Xm=sum(Xe)/2;
        Ym=sum(Ye)/2;
        Zm=sum(Ze)/2;
        elementname=(num2str(b));
        text(Xm,Ym,Zm,elementname,'Color','k')
    end
end
%% Reactions
if strcmp(disp_opt{2},'on')
    subplot(2,2,2);
    view(3)
    for j=1:NElement
        X=[gcords(nodeselements(j,:),1)];
        Y=[gcords(nodeselements(j,:),2)];
        Z=[gcords(nodeselements(j,:),3)];
        hold on
        plot3(X,Y,Z,'c','linewidth',2)
        plot3(X,Y,Z,'o','linewidth',2)
        grid on
        xlabel('X axis \rightarrow','Color','m')
        ylabel('Y axis \Rightarrow','Color','b')
        zlabel('Z axis \rightarrow','Color','g')
        title('Reactions')
    end
    RR=reshape(R,3,NJ);
    for a=1:NJ
        X=gcords(a,:);
        lod=RR(:,a)';
        bar(a,:)=[X lod];
    end
    for a=1:NJ
        X=bar(a,1);
        Y=bar(a,2);
        Z=bar(a,3);
        lodet=bar(a,4:6);
        for loadn=1:3
            LOADE=lodet(loadn);
            %         jahat = arrow(X0, Y0, Z0,LODE,loadn);
            str = {LOADE};
            if LOADE~=0
                if loadn==1
                    text(X,Y,Z,str,'Color','m','VerticalAlignment','cap','HorizontalAlignment','left')
                elseif loadn==2
                    text(X,Y,Z,str,'Color','b','VerticalAlignment','bottom','HorizontalAlignment','center')
                elseif loadn==3
                    text(X,Y,Z,str,'Color','g','VerticalAlignment','top','HorizontalAlignment','right')
                end
            end
        end
    end
end
%% Deformed Shape
if strcmp(disp_opt{3},'on')
  subplot(2,2,3);
    view(3)
    for j=1:NElement
        X=[gcords(nodeselements(j,:),1)];
        Y=[gcords(nodeselements(j,:),2)];
        Z=[gcords(nodeselements(j,:),3)];
        hold on
        plot3(X,Y,Z,'g','linewidth',2)
        plot3(X,Y,Z,'o','linewidth',2)
        grid on
        xlabel('X axis \rightarrow','Color','m')
        ylabel('Y axis \Rightarrow','Color','b')
        zlabel('Z axis \rightarrow','Color','g')
        title('Deformed Shape')
    end
    N_gcords=gcords+(W*SC);
    for j=1:NElement
        XX=[N_gcords(nodeselements(j,:),1)];
        YY=[N_gcords(nodeselements(j,:),2)];
        ZZ=[N_gcords(nodeselements(j,:),3)];
        hold on
        plot3(XX,YY,ZZ,'b--','linewidth',2)
        plot3(XX,YY,ZZ,'o','linewidth',2)
    end
end
%% Stress Plot
if strcmp(disp_opt{4},'on')
   subplot(2,2,4);
    view(3)
    cc=jet(length(Stress));
    AA=cell(1,length(Stress));
    for k=1:length(Stress)
        X=[gcords(nodeselements(k,:),1)];
        Y=[gcords(nodeselements(k,:),2)];
        Z=[gcords(nodeselements(k,:),3)];
        line([X(1) X(2)],[Y(1) Y(2)],[Z(1) Z(2)],'Color',cc(k,:),'Marker','.','MarkerSize', 15,'LineWidth',1.5);
        %     AA{1,k}=[num2str(Stress(k)),' Psi'];
        AA{1,k}=[num2str(Stress(k))];
    end
    legend(AA);
    grid on
    xlabel('X axis \rightarrow','Color','m')
    ylabel('Y axis \Rightarrow','Color','b')
    zlabel('Z axis \rightarrow','Color','g')
    title('Stress Plot')
end
end