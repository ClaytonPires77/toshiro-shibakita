<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Toshiro Shibakita - Cadastro Seguro</title>
    <style>
        body { font-family: system-ui, sans-serif; padding: 2rem; background: #0d1117; color: #c9d1d9; }
        .container { max-width: 800px; margin: auto; background: #161b22; padding: 2rem; border-radius: 12px; }
        .success { color: #56d364; }
        .error { color: #f85149; }
    </style>
</head>
<body>
<div class="container">
    <h1>Toshiro Shibakita</h1>
    <p><strong>PHP:</strong> <?= phpversion() ?></p>
    <p><strong>Host:</strong> <?= htmlspecialchars(gethostname(), ENT_QUOTES, 'UTF-8') ?></p>

<?php
// 1. NUNCA mais coloque credenciais no código!
require_once __DIR__ . '/config/database.php';  // <-- crie esse arquivo fora do web root

// 2. Desabilita exibição de erros em produção
ini_set('display_errors', '0');
ini_set('display_startup_errors', '0');
error_reporting(E_ALL);

// 3. Usa PDO + prepared statements (padrão desde 2015+)
try {
    $pdo = new PDO(
        "mysql:host={$db['host']};dbname={$db['name']};charset=utf8mb4",
        $db['user'],
        $db['pass'],
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );

    // Dados fictícios seguros
    $alunoId   = random_int(1, 999999);
    $token     = bin2hex(random_bytes(8));
    $nomeFake  = "Aluno_" . $token;
    $host      = gethostname();

    // Prepared statement = 100% protegido contra SQL Injection
    $sql = "INSERT INTO alunos (aluno_id, nome, sobrenome, endereco, cidade, host) 
            VALUES (:id, :nome, :sobrenome, :endereco, :cidade, :host)";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':id'        => $alunoId,
        ':nome'      => $nomeFake,
        ':sobrenome' => "Sobrenome_$token",
        ':endereco'  => "Rua Exemplo, 123",
        ':cidade'    => "São Paulo",
        ':host'      => $host
    ]);

    echo '<p class="success">Registro inserido com sucesso! ID: ' . $alunoId . '</p>';

} catch (PDOException $e) {
    // Nunca exponha a mensagem real para o usuário final
    error_log("Erro no banco: " . $e->getMessage());
    echo '<p class="error">Erro ao salvar dados. Tente novamente mais tarde.</p>';
} catch (Exception $e) {
    error_log("Erro geral: " . $e->getMessage());
    echo '<p class="error">Ocorreu um erro inesperado.</p>';
}
?>

</div>
</body>
</html>
