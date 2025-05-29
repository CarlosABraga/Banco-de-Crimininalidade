DROP PROCEDURE IF EXISTS dimensao_tempo;

DELIMITER //

CREATE PROCEDURE dimensao_tempo(IN startdate DATE, IN stopdate DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = DATE_FORMAT(startdate, '%Y-%m-01'); -- força para o primeiro dia do mês

    WHILE currentdate <= stopdate DO
        INSERT INTO dimtempo (
            IdTempo,
            Ano,
            Mes,
            Semestre,
            nome_mes
        )
        VALUES (
            CAST(DATE_FORMAT(currentdate, '%Y%m') AS UNSIGNED), -- ID como AAAAMM
            YEAR(currentdate),
            MONTH(currentdate),
            FLOOR(1 + (MONTH(currentdate) - 1) / 6),
            DATE_FORMAT(currentdate, '%M')
        );

        -- pula para o próximo mês
        SET currentdate = ADDDATE(currentdate, INTERVAL 1 MONTH);
    END WHILE;
END //

DELIMITER ;

CALL dimensao_tempo('2015-01-01','2022-12-31');

SELECT * FROM dimtempo LIMIT 1000;
