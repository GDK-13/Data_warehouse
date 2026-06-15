#!/usr/bin/env python3
"""
Script para criar a estrutura de diretórios do projeto Data Warehouse
Este script é executado APENAS UMA VEZ para setup inicial do projeto.

Estrutura criada:
lab_mysql_dw/
├── data/
│   ├── raw/                 (dados brutos - baixar Sample - Superstore.xlsx aqui)
│   └── staging/             (arquivos intermediários gerados pelos notebooks)
├── notebooks/               (Jupyter notebooks do projeto)
└── sql/                     (scripts SQL - DDL e queries)
"""

import os
import sys
from pathlib import Path


def criar_estrutura():
    """Cria a estrutura de diretórios do projeto"""
    
    # Diretório base do projeto
    base_dir = Path("lab_mysql_dw")
    
    # Estrutura de diretórios
    diretorios = [
        base_dir / "data" / "raw",
        base_dir / "data" / "staging",
        base_dir / "notebooks",
        base_dir / "sql",
    ]
    
    # Criar todos os diretórios
    print("=" * 60)
    print("CRIANDO ESTRUTURA DO PROJETO DATA WAREHOUSE")
    print("=" * 60)
    print()
    
    for diretorio in diretorios:
        try:
            diretorio.mkdir(parents=True, exist_ok=True)
            print(f"✓ Criado: {diretorio}")
        except Exception as e:
            print(f"✗ Erro ao criar {diretorio}: {e}")
            return False
    
    print()
    
    # Criar notebooks vazios
    notebooks = [
        ("01_read_excel.ipynb", "Leitura e exploração do arquivo Excel"),
        ("02_transform.ipynb", "Transformação e limpeza dos dados"),
        ("03_load_mysql.ipynb", "Carga dos dados no MySQL"),
        ("04_olap_queries.ipynb", "Queries analíticas OLAP"),
    ]
    
    print("Criando notebooks...")
    for notebook_name, descricao in notebooks:
        notebook_path = base_dir / "notebooks" / notebook_name
        try:
            # Criar notebook vazio com estrutura básica
            conteudo_notebook = {
                "cells": [
                    {
                        "cell_type": "markdown",
                        "metadata": {},
                        "source": [f"# {notebook_name.replace('_', ' ').replace('.ipynb', '')}\n", f"\n{descricao}"]
                    }
                ],
                "metadata": {
                    "kernelspec": {
                        "display_name": "Python 3",
                        "language": "python",
                        "name": "python3"
                    },
                    "language_info": {
                        "name": "python",
                        "version": "3.10.0"
                    }
                },
                "nbformat": 4,
                "nbformat_minor": 2
            }
            
            import json
            with open(notebook_path, "w", encoding="utf-8") as f:
                json.dump(conteudo_notebook, f, indent=2)
            
            print(f"  ✓ {notebook_name}")
        except Exception as e:
            print(f"  ✗ Erro ao criar {notebook_name}: {e}")
            return False
    
    print()
    
    # Criar arquivos SQL
    sql_files = [
        ("01_create_schema.sql", "-- DDL - Criar Schema e Tabelas\n-- Star Schema para análise de vendas\n"),
        ("02_olap_queries.sql", "-- OLAP Queries - Análises analíticas\n-- Queries para BI e relatórios\n"),
    ]
    
    print("Criando scripts SQL...")
    for sql_name, conteudo in sql_files:
        sql_path = base_dir / "sql" / sql_name
        try:
            with open(sql_path, "w", encoding="utf-8") as f:
                f.write(conteudo)
            print(f"  ✓ {sql_name}")
        except Exception as e:
            print(f"  ✗ Erro ao criar {sql_name}: {e}")
            return False
    
    print()
    
    # Criar arquivo README na pasta data
    readme_data = """# Pasta de Dados

## raw/
Contém os dados brutos do projeto.
- Baixar "Sample - Superstore.xlsx" do Kaggle e colocar neste diretório
- Link: https://www.kaggle.com/datasets/

## staging/
Contém os arquivos intermediários (CSV) gerados pelos notebooks.
- orders_staging.csv ← gerado no notebook 01
- returns_staging.csv ← gerado no notebook 01
- people_staging.csv ← gerado no notebook 01
- metas_regionais.csv ← gerado no notebook 01
"""
    
    try:
        readme_path = base_dir / "data" / "README.md"
        with open(readme_path, "w", encoding="utf-8") as f:
            f.write(readme_data)
        print("✓ Criado: data/README.md")
    except Exception as e:
        print(f"✗ Erro ao criar README.md: {e}")
        return False
    
    print()
    print("=" * 60)
    print("✓ ESTRUTURA DO PROJETO CRIADA COM SUCESSO!")
    print("=" * 60)
    print()
    print("Próximos passos:")
    print("1. Navegue para: cd lab_mysql_dw")
    print("2. Baixe 'Sample - Superstore.xlsx' do Kaggle")
    print("3. Coloque o arquivo em: data/raw/")
    print("4. Ative o ambiente virtual: .\\venv_mysql_dw\\Scripts\\activate")
    print("5. Inicie o Jupyter: jupyter notebook")
    print()
    
    return True


if __name__ == "__main__":
    try:
        sucesso = criar_estrutura()
        sys.exit(0 if sucesso else 1)
    except KeyboardInterrupt:
        print("\n✗ Operação cancelada pelo usuário")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ Erro inesperado: {e}")
        sys.exit(1)
