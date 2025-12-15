
async def get_search_queries_all_indicators(
    self,
    host_id: str,
    date_from: str,
    date_to: str,
    device_type: str = "ALL",
    limit: int = 500,
    offset: int = 0
) -> Dict:
    """
    Получение поисковых запросов со всеми доступными индикаторами
    Использует другой подход к запросу данных
    """
    
    # Список всех возможных индикаторов согласно документации
    query_indicators = [
        "TOTAL_SHOWS",
        "TOTAL_CLICKS", 
        "AVG_SHOW_POSITION",
        "AVG_CLICK_POSITION",
        "CTR"
    ]
    
    params = {
        "date_from": date_from,
        "date_to": date_to,
        "device_type_indicator": device_type,
        "limit": limit,
        "offset": offset,
        "query_indicator": query_indicators  # Явно запрашиваем индикаторы
    }
    
    try:
        # Получаем user_id
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        # Получаем запросы
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/popular",
            params=params
        )
        
        return data
    
    except Exception as e:
        logger.error(f"Failed to get search queries with all indicators")
        log_exception(logger, e, "get_search_queries_all_indicators")
        raise

