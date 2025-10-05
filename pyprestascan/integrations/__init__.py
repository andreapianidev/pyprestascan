"""
Modulo integrazioni esterne (PrestaShop API, Excel Export, etc.)
"""
from .prestashop_api import PrestaShopAPIClient
from .excel_exporter import ExcelReportExporter

__all__ = [
    'PrestaShopAPIClient',
    'ExcelReportExporter'
]
