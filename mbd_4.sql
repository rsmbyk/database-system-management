use mbd_praktikum_1;

--------------------------------------------------------------------------------
------------------------------------- join -------------------------------------

select   concat(film.nama_film, ' telah diputar sebanyak ', count(*), ' kali.') "DBMS_OUTPUT"
from     memutar join film on memutar.id_film = film.id_film
group by memutar.id_film;

select   concat(f1.nama_film, " mulai tayang setelah ", f2.nama_film) 'DBMS_OUTPUT'
from     film f1
         inner join film f2
         on         f1.tgl_mulai_tayang > f2.tgl_mulai_tayang;

--------------------------------------------------------------------------------
-------------------------------- implicitcursor --------------------------------
delimiter $$
create procedure implicit_cursor ()
begin
    update transaksi
    set    harga_pertiket = 30000
    where  jumlah_tiket > 20;

    -- row_count untuk update/delete/insert
    if row_count() > 0 then
        select concat("Ada ", row_count(), " traksaksi yang mendapat potongan harga tiket") "DBMS_OUTPUT";
    else
        select "Tidak ada yang mendapat potongan harga_tiket" "DBMS_OUTPUT";
    end if;
end$$
delimiter ;

-- test
call implicit_cursor ();

--------------------------------------------------------------------------------
-------------------------------- explicitcursor --------------------------------
delimiter $$
create procedure explicit_cursor ()
begin
    declare list_nama varchar (1000);
    declare nama      varchar (100);
    declare done      bool default false;

    declare pegawai_cursor cursor for
        select nama_pegawai
        from   pegawai;

    declare continue handler for
        not found set done = true;

    set list_nama = "";
    open pegawai_cursor;
    retrieve_pegawai: loop
        fetch pegawai_cursor into nama;
        if done = true then
            leave retrieve_pegawai;
        end if;
        set list_nama = concat(list_nama, ", ", nama);
    end loop retrieve_pegawai;
    select list_nama "List Pegawai";
    close pegawai_cursor;
end$$
delimiter ;

-- test
call explicit_cursor ();

--------------------------------------------------------------------------------
----------------------------------- sequence -----------------------------------

create table contoh_sequence (
    sequence int auto_increment,
    primary key (sequence)
);