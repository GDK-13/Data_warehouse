#!/usr/bin/env python3
"""
Script para instalar todas as dependências do projeto Data Warehouse
Dependências:
- Python 3.10+
- Jupyter Notebook 7.x
- pandas 2.x
- openpyxl 3.x
- mysql-connector-python 8.x
- SQLAlchemy 2.x
- pymysql
"""

import subprocess
import sys
from packaging import version # pyright: ignore[reportMissingImports]

def verificar_versao_python():
    """Verifica se a versão do Python é 3.10 ou superior"""
    versao_atual = f"{sys.version_info.major}.{sys.version_info.minor}"
    print(f"✓ Versão do Python: {versao_atual}")
    
    if sys.version_info < (3, 10):
        print("✗ Erro: Python 3.10+ é requerido!")
        print(f"  Versão atual: {versao_atual}")
        print("  Faça download em: https://www.python.org/downloads/")
        sys.exit(1)
    print("  ✓ Python 3.10+ OK\n")

def instalar_pacotes():
    """Instala todos os pacotes necessários"""
    pacotes = [
        ("notebook", "Jupyter Notebook 7.x"),
        ("pandas", "pandas 2.x"),
        ("openpyxl", "openpyxl 3.x"),
        ("mysql-connector-python", "mysql-connector-python 8.x"),
        ("sqlalchemy", "SQLAlchemy 2.x"),
        ("pymysql", "PyMySQL"),
    ]
    
    print("Iniciando instalação de pacotes...\n")
    
    pacotes_falhados = []
    
    for pacote, descricao in pacotes:
        try:
            print(f"Instalando {descricao}...", end=" ")
            subprocess.check_call(
                [sys.executable, "-m", "pip", "install", "--upgrade", pacote],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            print("✓ Instalado com sucesso")
        except subprocess.CalledProcessError:
            print(f"✗ Falha na instalação")
            pacotes_falhados.append(pacote)
        except Exception as e:
            print(f"✗ Erro: {str(e)}")
            pacotes_falhados.append(pacote)
    
    print("\n" + "="*60)
    
    if pacotes_falhados:
        print("⚠ Alguns pacotes falharam na instalação:")
        for pacote in pacotes_falhados:
            print(f"  - {pacote}")
        print("\nTente instalar manualmente com:")
        print(f"  python -m pip install {' '.join(pacotes_falhados)}")
        return False
    else:
        print("✓ Todas as dependências foram instaladas com sucesso!")
        return True

def listar_pacotes_instalados():
    """Lista todos os pacotes instalados"""
    print("\nPacotes instalados:")
    print("-" * 60)
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "list"])
    except subprocess.CalledProcessError as e:
        print(f"Erro ao listar pacotes: {e}")

def main():
    print("="*60)
    print("Instalador de Dependências - Data Warehouse")
    print("="*60)
    print()
    
    # Verificar versão do Python
    verificar_versao_python()
    
    # Instalar pacotes
    sucesso = instalar_pacotes()
    
    # Listar pacotes instalados
    listar_pacotes_instalados()
    
    print("\n" + "="*60)
    if sucesso:
        print("✓ Instalação concluída com sucesso!")
        print("Você pode começar a usar o ambiente agora.")
    else:
        print("⚠ Instalação concluída com alguns problemas.")
        print("Verifique os erros acima.")
    print("="*60)

if __name__ == "__main__":
    main()
