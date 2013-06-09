%%Plot topology utility

function plot_topology(posMatrix, conn_matr)

S=40;
C='b';
scatter(posMatrix(:,1),posMatrix(:,2),S,C,'filled');

for i=1:size(conn_matr,1)
    for j=i+1:size(conn_matr,2)
        if conn_matr(i,j)==1
            line([posMatrix(i,1) posMatrix(j,1)],[posMatrix(i,2) posMatrix(j,2)],'Color','k');
        end
    end
end
