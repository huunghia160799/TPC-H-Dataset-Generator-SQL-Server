-- using 200 as a seed to the RNG


set showplan_all on;
go

select
	o_year,
	sum(case
		when nation = 'VIETNAM' then volume
		else 0
	end) / sum(volume) as mkt_share
from
	(
		select
			datepart(yy, o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) as volume,
			n2.n_name as nation
		from
			part,
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2,
			region
		where
			p_partkey = l_partkey
			and s_suppkey = l_suppkey
			and l_orderkey = o_orderkey
			and o_custkey = c_custkey
			and c_nationkey = n1.n_nationkey
			and n1.n_regionkey = r_regionkey
			and r_name = 'ASIA'
			and s_nationkey = n2.n_nationkey
			and o_orderdate between cast('1995-01-01' as datetime) and cast('1996-12-31' as datetime)
			and p_type = 'PROMO POLISHED TIN'
	) as all_nations
group by
	o_year
order by
	o_year;
go
