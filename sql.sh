#！/bin/bash

args=(/Users/wangjinling/test.sql data=qf_scratch_ds.collection_m1_scr_06)
echo ${args[@]}
sql=${args[0]}
unset args[0]

#replace the parameters in sql
tmp_sql=${sql%%.*}_tmp.sql
cp ${sql} ${tmp_sql}
for arg in ${args[@]}; do
	arg=(${arg//=/ })
	name={${arg[0]}}
	cat ${tmp_sql} | sed "s/${name}/${arg[1]}/g" > ${tmp_sql}_1 #flag
	mv ${tmp_sql}_1 ${tmp_sql}
done

#split sql by ';'
awk 'BEGIN{
	rno[0]=0;
	count=0
	} 
	/;/{
		count++; 
		rno[count]=NR
		} 
	END{
		for (i=0;i<count;i++)
		{
			printf("sed -n '\''%s,%sp'\'' %s > %s_%s.sql\n",rno[i]+1,rno[i+1],"'${tmp_sql}'","'${tmp_sql%%.*}'",i)
		}
		}' ${tmp_sql} | bash  #flag 引号内引用外变量

#execute each sql
sqls=$(ls ${tmp_sql%%.*}_*)
echo ${sqls[@]}
for sql_str in ${sqls[@]}; do
	echo "The sql script:"
	cat ${sql_str}
done

